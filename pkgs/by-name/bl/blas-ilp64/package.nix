{
  blas,
  ...
}@args:

blas.override (
  {
    isILP64 = true;
  }
  // removeAttrs args [ "blas" ]
)
