{
  lib,
  hdf5,
  ...
}@args:

lib.pipe args [
  (
    attrs:
    removeAttrs attrs [
      "lib"
      "hdf5"
    ]
  )
  (lib.mergeAttrs {
    fortranSupport = true;
    mpiSupport = true;
    cppSupport = false;
  })
  hdf5.override
]
