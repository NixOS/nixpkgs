{
  highfive,
  hdf5-mpi,
  ...
}@args:

highfive.override (
  {
    hdf5 = hdf5-mpi;
  }
  // removeAttrs args [
    "highfive"
    "hdf5-mpi"
  ]
)
