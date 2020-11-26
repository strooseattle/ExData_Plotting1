## load libraries
library(ggplot2)
library(readr)
library(dplyr)


## download data
rawDataDir <- "./rawData"
rawDataUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
rawDataFilename <- "rawData.zip"
rawDataDFn <- paste(rawDataDir, "/", "rawData.zip", sep = "")
dataDir <- "./data"

if (!file.exists(rawDataDir)) {
  dir.create(rawDataDir)
  download.file(url = rawDataUrl, destfile = rawDataDFn)
}
if (!file.exists(dataDir)) {
  dir.create(dataDir)
  unzip(zipfile = rawDataDFn, exdir = dataDir)
}

## set up dataframe of semicolon separated values as a tibble

df <- read_csv2(paste(sep = "", dataDir, "/household_power_consumption.txt"), 
                col_names = TRUE)

## subset tibble to just rows containing observations on Feb 1-2 of 2007

df2 <- filter(df, Date == "2/2/2007" | Date == "1/2/2007")

## convert Date column values from strings to dates

df2$Date <- as.Date(df2$Date, format = "%d/%m/%Y")

## Merge date and time into a single object

df2$Datetime <- as.POSIXct(paste(df2$Date, df2$Time))

## convert Global_active_power column values to numeric

df2$Global_active_power <- as.numeric(df2$Global_active_power)

## set graphic device to PNG

png("plot1.png", width=480, height=480)

## Generate line plot

with(df2, plot(Datetime, Global_active_power, type="l", 
    xlab="Global Active Power (kilowatts)"))

## Shut down the PNG device

dev.off()

