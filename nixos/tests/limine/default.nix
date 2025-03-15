{
  runTest,
  ...
}:
{
  checksum = runTest ./checksum.nix;
  uefi = runTest ./uefi.nix;
}
