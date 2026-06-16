{
  dmenu-rs,
  ...
}@args:

dmenu-rs.override (
  {
    enablePlugins = true;
  }
  // removeAttrs args [ "dmenu-rs" ]
)
