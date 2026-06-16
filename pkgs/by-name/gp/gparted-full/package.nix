{
  gparted,
  ...
}@args:

gparted.override (
  {
    withAllTools = true;
  }
  // removeAttrs args [ "gparted" ]
)
