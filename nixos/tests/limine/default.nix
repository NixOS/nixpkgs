{
  runTest,
}:
{
  additionalFiles = runTest ./additional-files.nix;
  bios = runTest ./bios.nix;
  checksum = runTest ./checksum.nix;
  secureBoot = runTest ./secure-boot.nix;
  specialisations = runTest ./specialisations.nix;
  stableEntry = runTest ./stable-entry.nix;
  uefi = runTest ./uefi.nix;
  distroName = runTest ./distroName.nix;
}
