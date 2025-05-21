{
  runTest,
  ...
}:
{
  checksum = runTest ./checksum.nix;
  secureBoot = runTest ./secure-boot.nix;
  specialisations = runTest ./specialisations.nix;
  uefi = runTest ./uefi.nix;
}
