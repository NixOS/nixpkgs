{
  libxcrypt,
  ...
}@args:

libxcrypt.override (
  {
    enableHashes = "all";
  }
  // removeAttrs args [ "libxcrypt" ]
)
