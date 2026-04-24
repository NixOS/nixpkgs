{
  hdf5,
  ...
}@args:

hdf5.override (
  {
    fortranSupport = true;
    mpiSupport = true;
    cppSupport = false;
  }
  // removeAttrs args [ "hdf5" ]
)
