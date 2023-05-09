{ lib }:

lib.mapAttrs (old: new: platform:
  lib.warn "`rust.${old} platform` is deprecated. Use `platform.rust.${new}` instead."
    platform.rust.${new})
{
  toTargetArch = "targetArch";
  toTargetOs = "targetOs";
  toTargetFamily = "targetFamily";
  toTargetVendor = "targetVendor";
  toRustTarget = "target";
  toRustTargetSpec = "targetSpec";
  IsNoStdTarget = "isNoStdTarget";
}
