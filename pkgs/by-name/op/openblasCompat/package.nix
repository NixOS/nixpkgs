{
  openblas,
  ...
}@args:

openblas.override (
  {
    blas64 = false;
  }
  // removeAttrs args [ "openblas" ]
)
