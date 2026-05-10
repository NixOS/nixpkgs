{
  nwjs,
  ...
}@args:

nwjs.override (
  {
    sdk = true;
  }
  // removeAttrs args [ "nwjs" ]
)
