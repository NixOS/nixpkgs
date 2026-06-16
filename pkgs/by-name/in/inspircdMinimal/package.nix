{
  inspircd,
  ...
}@args:

inspircd.override (
  {
    extraModules = [ ];
  }
  // removeAttrs args [ "inspircd" ]
)
