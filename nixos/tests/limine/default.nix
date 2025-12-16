{
  runTest,
  ...
}:
{
  bios = runTest ./bios.nix;
  checksum = runTest ./checksum.nix;
  secureBoot = runTest ./secure-boot.nix;
  specialisations = runTest ./specialisations.nix;
  uefi = runTest ./uefi.nix;

  secureBootWithUki = runTest ./secure-boot-with-uki.nix;
  specialisationsWithUki = runTest ./specialisations-with-uki.nix;
}
