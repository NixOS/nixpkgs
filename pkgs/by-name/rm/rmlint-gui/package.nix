{
  rmlint,
  ...
}@args:

rmlint.override (
  {
    withGui = true;
  }
  // removeAttrs args [ "rmlint" ]
)
