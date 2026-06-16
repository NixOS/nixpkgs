{
  seabios,
  ...
}@args:

seabios.override (
  {
    ___build-type = "csm";
  }
  // removeAttrs args [ "seabios" ]
)
