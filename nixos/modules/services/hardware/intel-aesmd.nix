{ config, lib, pkgs, utils, ... }:

with lib;

let

  cfg = config.services.intel-aesmd;

in {

  options.services.intel-aesmd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable Intel's Architectural Enclave Service Manager for Intel SGX
      '';
    };
  };

  options.services.intel-aesmd.package = mkOption {
    type = types.package;
    default = pkgs.intel-aesmd;
    defaultText = "pkgs.intel-aesmd";
    description = ''
      aesmd derivation to use.
    '';
  };

  config = mkIf cfg.enable {
    users.groups.aesmd = {
    };

    users.users.aesmd = {
      description = "aesmd user";
    };

    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    systemd.services.aesmd.wantedBy = [ "multi-user.target" ];
    hardware.cpu.intel.sgx.enable = true;
  };
}
