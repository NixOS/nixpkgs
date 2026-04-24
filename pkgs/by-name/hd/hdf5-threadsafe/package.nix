{
  hdf5,
  ...
}@args:

hdf5.override (
  {
    cppSupport = false;
    threadsafe = true;
  }
  // removeAttrs args [ "hdf5" ]
)
