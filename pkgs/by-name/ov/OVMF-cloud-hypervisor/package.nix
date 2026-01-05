{ lib, OVMF }:

OVMF.override {
  projectDscPath = "OvmfPkg/CloudHv/CloudHvX64.dsc";
  fwPrefix = "CLOUDHV";
  metaPlatforms = builtins.filter (lib.hasPrefix "x86_64-") OVMF.meta.platforms;
}
