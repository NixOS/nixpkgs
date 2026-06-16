{
  lapack,
  ...
}@args:

lapack.override (
  {
    isILP64 = true;
  }
  // removeAttrs args [ "lapack" ]
)
