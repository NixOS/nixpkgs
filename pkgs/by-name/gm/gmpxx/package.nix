{
  gmp,
  ...
}@args:

gmp.override (
  {
    cxx = true;
  }
  // removeAttrs args [ "gmp" ]
)
