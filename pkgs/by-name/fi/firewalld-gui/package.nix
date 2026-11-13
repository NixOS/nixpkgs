{
  firewalld,
  ...
}@args:

firewalld.override (
  {
    withGui = true;
  }
  // removeAttrs args [ "firewalld" ]
)
