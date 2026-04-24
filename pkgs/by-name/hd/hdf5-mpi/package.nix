{
  hdf5,
  ...
}@args:

hdf5.override (
  {
    mpiSupport = true;
    cppSupport = false;
  }
  // removeAttrs args [ "hdf5" ]
)
