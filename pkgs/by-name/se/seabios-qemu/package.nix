{
  seabios,
  ...
}@args:

seabios.override (
  {
    ___build-type = "qemu";
  }
  // removeAttrs args [ "seabios" ]
)
