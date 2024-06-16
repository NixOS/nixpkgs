{ lib, ovmf }:

ovmf.override {
  projectDscPath = "OvmfPkg/CloudHv/CloudHvX64.dsc";
  fwPrefix = "CLOUDHV";
  metaPlatforms = builtins.filter (lib.hasPrefix "x86_64-") ovmf.meta.platforms;
}
