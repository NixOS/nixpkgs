{
  htop,
  ...
}@args:

htop.override (
  {
    withVimKeys = true;
  }
  // removeAttrs args [ "htop" ]
)
