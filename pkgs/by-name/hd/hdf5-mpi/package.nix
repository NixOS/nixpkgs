# pkgs/by-name/hd/hdf5-mpi/package.nix
{
  hdf5,
  mpi,
  usev110Api ? false,
}:

hdf5.override {
  mpiSupport = true;
  cppSupport = false;
  inherit mpi usev110Api;
}
