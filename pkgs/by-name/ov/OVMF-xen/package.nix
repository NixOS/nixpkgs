{ lib, OVMF }:

(OVMF.override {
  projectDscPath = "OvmfPkg/OvmfXen.dsc";
  fwPrefix = "OVMF";
  metaPlatforms = builtins.filter (lib.hasPrefix "x86_64-") OVMF.meta.platforms;
}).overrideAttrs
  (oldAttrs: {
    __structuredAttrs = true;

    pname = "OVMF-xen";

    meta = oldAttrs.meta // {
      description = "Sample UEFI firmware for Xen guests";
      teams = [ lib.teams.xen ];
    };
  })
