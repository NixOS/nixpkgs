{
  geoclue2,
  ...
}@args:

geoclue2.override (
  {
    withDemoAgent = true;
  }
  // removeAttrs args [ "geoclue2" ]
)
