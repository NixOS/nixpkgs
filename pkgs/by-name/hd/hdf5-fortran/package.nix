{
  hdf5,
  ...
}@args:

hdf5.override (
  {
    fortranSupport = true;
  }
  // removeAttrs args [ "hdf5" ]
)
