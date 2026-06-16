{
  rstudio,
  ...
}@args:

rstudio.override (
  {
    server = true;
  }
  // removeAttrs args [ "rstudio" ]
)
