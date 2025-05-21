{
  runTest,
  ...
}:
{
  checksum = runTest ./checksum.nix;
  secureBoot = runTest ./secure-boot.nix;
  uefi = runTest ./uefi.nix;
}
