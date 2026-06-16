{
  arpack,
  ...
}@args:

arpack.override (
  {
    useMpi = true;
  }
  // removeAttrs args [ "arpack" ]
)
