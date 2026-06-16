{
  rstudioWrapper,
  rstudio-server,
}:

rstudioWrapper.override { rstudio = rstudio-server; }
