{
  pmars,
  ...
}@args:

pmars.override (
  {
    enableXwinGraphics = true;
  }
  // removeAttrs args [ "pmars" ]
)
