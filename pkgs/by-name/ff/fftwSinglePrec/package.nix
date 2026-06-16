{
  fftw,
  ...
}@args:

fftw.override (
  {
    precision = "single";
  }
  // removeAttrs args [ "fftw" ]
)
