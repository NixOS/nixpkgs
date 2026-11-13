{
  mtr,
  ...
}@args:

mtr.override (
  {
    withGtk = true;
  }
  // removeAttrs args [ "mtr" ]
)
