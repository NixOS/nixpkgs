{
  system ? builtins.currentSystem,
  ...
}:
{
  checksum = import ./checksum.nix { inherit system; };
  uefi = import ./uefi.nix { inherit system; };
}
