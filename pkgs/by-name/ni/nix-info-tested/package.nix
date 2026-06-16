{
  nix-info,
  ...
}@args:

nix-info.override (
  {
    doCheck = true;
  }
  // removeAttrs args [ "nix-info" ]
)
