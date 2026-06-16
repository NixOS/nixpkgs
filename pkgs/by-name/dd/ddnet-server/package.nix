{
  ddnet,
  ...
}@args:

ddnet.override (
  {
    buildClient = false;
  }
  // removeAttrs args [ "ddnet" ]
)
