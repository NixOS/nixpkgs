{
  rstudioWrapper,
  rstudio-server,
  ...
}@args:

rstudioWrapper.override (
  {
    rstudio = rstudio-server;
  }
  // removeAttrs args [
    "rstudioWrapper"
    "rstudio-server"
  ]
)
