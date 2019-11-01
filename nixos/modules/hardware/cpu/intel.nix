{ config, lib, pkgs, ... }:

with lib;

let

  intel = config.hardware.cpu.intel;

in {

  ###### interface

  options = {

    hardware.cpu.intel.updateMicrocode = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Update the CPU microcode for Intel processors.
      '';
    };

    hardware.cpu.intel.sgx = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable SGX.
          This will allow SGX enclaves to be loaded, assuming SGX is enabled in the BIOS.
          Note: loading this driver taints the kernel
        '';
      };
    };

    hardware.cpu.intel.aesmd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable Intel's Architectural Enclave Service Manager for Intel SGX
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.intel-aesmd;
        defaultText = "pkgs.intel-aesmd";
        description = ''
          aesmd derivation to use.
        '';
      };
    };
  };


  ###### implementation

  config = mkMerge [
    (mkIf intel.updateMicrocode {
      # Microcode updates must be the first item prepended in the initrd
      boot.initrd.prepend = mkOrder 1 [ "${pkgs.microcodeIntel}/intel-ucode.img" ];
    })

    (mkIf (intel.sgx.enable || intel.aesmd.enable) {
      boot.kernelModules = [ "isgx" ];
      boot.extraModulePackages = [ config.boot.kernelPackages.intel-sgx ];
    })

    (mkIf intel.aesmd.enable {
      users.groups.aesmd = {
      };

      users.users.aesmd = {
        description = "aesmd user";
        isSystemUser = true;
      };

      systemd.packages = [ intel.aesmd.package ];
      systemd.services.aesmd.wantedBy = [ "multi-user.target" ];
      hardware.cpu.intel.sgx.enable = true;
    })
  ];

}
