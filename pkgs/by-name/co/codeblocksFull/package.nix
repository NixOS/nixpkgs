{
  codeblocks,
  ...
}@args:

codeblocks.override (
  {
    contribPlugins = true;
  }
  // removeAttrs args [ "codeblocks" ]
)
