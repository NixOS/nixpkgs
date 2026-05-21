{ lib, OVMF }:

OVMF.override {
  projectDscPath = "OvmfPkg/OvmfXen.dsc";
  fwPrefix = "OVMF";
  metaDescription = "Sample UEFI firmware for Xen guests";
  metaTeams = [ lib.teams.xen ];
  metaPlatforms = builtins.filter (lib.hasPrefix "x86_64-") OVMF.meta.platforms;
}
