{
  pinegrow,
  ...
}@args:

pinegrow.override (
  {
    pinegrowVersion = "6";
  }
  // removeAttrs args [ "pinegrow" ]
)
