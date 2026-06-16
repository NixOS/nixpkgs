{
  jack2,
  ...
}@args:

jack2.override (
  {
    prefix = "lib";
  }
  // removeAttrs args [ "jack2" ]
)
