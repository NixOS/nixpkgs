{
  lib,
  netcdf,
  hdf5-mpi,
  ...
}@args:

lib.pipe args [
  (
    attrs:
    removeAttrs attrs [
      "lib"
      "netcdf"
      "hdf5-mpi"
    ]
  )
  (lib.mergeAttrs {
    hdf5 = hdf5-mpi.override { apiVersion = "v110"; };
  })
  netcdf.override
]
