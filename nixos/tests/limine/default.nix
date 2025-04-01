{
  runTest,
  ...
}:
{
  bios = runTest ./bios.nix;
  checksum = runTest ./checksum.nix;
  uefi = runTest ./uefi.nix;
}
