{
  fftw,
  ...
}@args:

fftw.override (
  {
    enableMpi = true;
  }
  // removeAttrs args [ "fftw" ]
)
