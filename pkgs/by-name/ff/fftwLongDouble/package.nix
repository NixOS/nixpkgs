{
  fftw,
  ...
}@args:

fftw.override (
  {
    precision = "long-double";
  }
  // removeAttrs args [ "fftw" ]
)
