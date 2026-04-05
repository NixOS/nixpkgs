{
  hdf5,
}:

hdf5.override {
  fortranSupport = true;
  mpiSupport = true;
  cppSupport = false;
}
