{ config, lib, ... }:
with lib;
let
  cfg = config.hardware.cpu.intel.sgx.provision;
  defaultGroup = "sgx_prv";
in
{
  options.hardware.cpu.intel.sgx.provision = {
    enable = mkEnableOption "access to the Intel SGX provisioning device";
    user = mkOption {
      description = "Owner to assign to the SGX provisioning device.";
      type = types.str;
      default = "root";
    };
    group = mkOption {
      description = "Group to assign to the SGX provisioning device.";
      type = types.str;
      default = defaultGroup;
    };
    mode = mkOption {
      description = "Mode to set for the SGX provisioning device.";
      type = types.str;
      default = "0660";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = hasAttr cfg.user config.users.users;
        message = "Given user does not exist";
      }
      {
        assertion = (cfg.group == defaultGroup) || (hasAttr cfg.group config.users.groups);
        message = "Given group does not exist";
      }
    ];

    users.groups = optionalAttrs (cfg.group == defaultGroup) {
      "${cfg.group}" = { };
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="misc", KERNEL=="sgx_provision", OWNER="${cfg.user}", GROUP="${cfg.group}", MODE="${cfg.mode}"
    '';
  };
}
