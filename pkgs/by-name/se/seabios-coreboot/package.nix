{
  seabios,
  ...
}@args:

seabios.override (
  {
    ___build-type = "coreboot";
  }
  // removeAttrs args [ "seabios" ]
)
