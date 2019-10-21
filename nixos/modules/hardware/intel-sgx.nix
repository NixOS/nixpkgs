{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.cpu.intel.sgx;
in
{
  options = {
    hardware.cpu.intel.sgx = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable SGX.
          This will allow SGX enclaves to be loaded, assuming SGX is enabled in the BIOS.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
     boot.kernelModules = [ "isgx" ];
     boot.extraModulePackages = [ config.boot.kernelPackages.intel-sgx ];
  };
}
