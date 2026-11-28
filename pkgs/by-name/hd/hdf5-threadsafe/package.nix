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
    cppSupport = false;
    threadsafe = true;
  })
  hdf5.override
]
