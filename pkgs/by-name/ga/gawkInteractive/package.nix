{
  gawk,
  ...
}@args:

gawk.override (
  {
    interactive = true;
  }
  // removeAttrs args [ "gawk" ]
)
