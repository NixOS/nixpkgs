{ config, lib, ... }:
with lib;
let
  cfg = config.hardware.cpu.amd.sev;
  defaultGroup = "sev";
in
  with lib; {
    options.hardware.cpu.amd.sev = {
      enable = mkEnableOption "access to the AMD SEV device";
      user = mkOption {
        description = lib.mdDoc "Owner to assign to the SEV device.";
        type = types.str;
        default = "root";
      };
      group = mkOption {
        description = lib.mdDoc "Group to assign to the SEV device.";
        type = types.str;
        default = defaultGroup;
      };
      mode = mkOption {
        description = lib.mdDoc "Mode to set for the SEV device.";
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

      boot.extraModprobeConfig = ''
        options kvm_amd sev=1
      '';

      users.groups = optionalAttrs (cfg.group == defaultGroup) {
        "${cfg.group}" = {};
      };

      services.udev.extraRules = with cfg; ''
        KERNEL=="sev", OWNER="${user}", GROUP="${group}", MODE="${mode}"
      '';
    };
  }
