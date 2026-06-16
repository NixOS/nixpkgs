{
  davix,
  ...
}@args:

davix.override (
  {
    enableThirdPartyCopy = true;
  }
  // removeAttrs args [ "davix" ]
)
