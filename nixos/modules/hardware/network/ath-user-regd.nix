{ config, lib, pkgs, ... }:

with lib;
let
  kernelVersion = config.boot.kernelPackages.kernel.version;
  linuxKernelMinVersion = "5.8";
  kernelPatch = pkgs.kernelPatches.ath_regd_optional // {
    extraConfig = ''
      ATH_USER_REGD y
    '';
  };
in
{
  options.networking.wireless.athUserRegulatoryDomain = mkOption {
    default = false;
    type = types.bool;
    description = lib.mdDoc ''
      If enabled, sets the ATH_USER_REGD kernel config switch to true to
      disable the enforcement of EEPROM regulatory restrictions for ath
      drivers. Requires at least Linux ${linuxKernelMinVersion}.
    '';
  };

  config = mkIf config.networking.wireless.athUserRegulatoryDomain {
    assertions = singleton {
      assertion = lessThan 0 (builtins.compareVersions kernelVersion linuxKernelMinVersion);
      message = "ATH_USER_REGD patch for kernels older than ${linuxKernelMinVersion} not ported yet!";
    };
    boot.kernelPatches = [ kernelPatch ];
  };
}
