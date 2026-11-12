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
  })
  hdf5.override
]
