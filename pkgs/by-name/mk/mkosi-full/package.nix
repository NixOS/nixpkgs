{
  mkosi,
  ...
}@args:

mkosi.override (
  {
    withQemu = true;
  }
  // removeAttrs args [ "mkosi" ]
)
