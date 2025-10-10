{
  lib,
  OVMF,
  stdenv,
}:

OVMF.override {
  projectDscPath =
    (lib.optionalString (stdenv.hostPlatform.isx86) "OvmfPkg/CloudHv/CloudHvX64.dsc")
    + (lib.optionalString (stdenv.hostPlatform.isAarch64) "ArmVirtPkg/ArmVirtCloudHv.dsc");

  fwPrefix = "CLOUDHV";
  metaPlatforms = builtins.filter (
    platform: (lib.hasPrefix "x86_64-" platform) || (lib.hasPrefix "aarch64-" platform)
  ) OVMF.meta.platforms;
}
