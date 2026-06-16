{
  arduino-core,
  ...
}@args:

arduino-core.override (
  {
    withGui = true;
  }
  // removeAttrs args [ "arduino-core" ]
)
