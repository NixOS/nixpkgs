{
  gpm,
  ...
}@args:

gpm.override (
  {
    withNcurses = true;
  }
  // removeAttrs args [ "gpm" ]
)
