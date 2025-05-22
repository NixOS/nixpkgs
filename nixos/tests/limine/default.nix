{
  runTest,
  ...
}:
{
  checksum = runTest ./checksum.nix;
  secureboot = runTest ./secure-boot.nix;
  specialisations = runTest ./specialisations.nix;
  uefi = runTest ./uefi.nix;
}
