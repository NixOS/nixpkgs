{
  botan3,
  ...
}@args:

botan3.override (
  {
    withEsdm = true;
  }
  // removeAttrs args [ "botan3" ]
)
