{
  hdf5,
  ...
}@args:

hdf5.override (
  {
    cppSupport = true;
  }
  // removeAttrs args [ "hdf5" ]
)
