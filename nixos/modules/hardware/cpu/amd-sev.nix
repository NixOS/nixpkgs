{ config, options, lib, ... }:
with lib;
let
  cfgSev = config.hardware.cpu.amd.sev;
  cfgSevGuest = config.hardware.cpu.amd.sevGuest;

  optionsFor = device: group: {
    enable = mkEnableOption (lib.mdDoc "access to the AMD ${device} device");
    user = mkOption {
      description = lib.mdDoc "Owner to assign to the ${device} device.";
      type = types.str;
      default = "root";
    };
    group = mkOption {
      description = lib.mdDoc "Group to assign to the ${device} device.";
      type = types.str;
      default = group;
    };
    mode = mkOption {
      description = lib.mdDoc "Mode to set for the ${device} device.";
      type = types.str;
      default = "0660";
    };
  };
in
with lib; {
  options.hardware.cpu.amd.sev = optionsFor "SEV" "sev";

  options.hardware.cpu.amd.sevGuest = optionsFor "SEV guest" "sev-guest";

  config = mkMerge [
    # /dev/sev
    (mkIf cfgSev.enable {
      assertions = [
        {
          assertion = hasAttr cfgSev.user config.users.users;
          message = "Given user does not exist";
        }
        {
          assertion = (cfgSev.group == options.hardware.cpu.amd.sev.group.default) || (hasAttr cfgSev.group config.users.groups);
          message = "Given group does not exist";
        }
      ];

      boot.extraModprobeConfig = ''
        options kvm_amd sev=1
      '';

      users.groups = optionalAttrs (cfgSev.group == options.hardware.cpu.amd.sev.group.default) {
        "${cfgSev.group}" = { };
      };

      services.udev.extraRules = with cfgSev; ''
        KERNEL=="sev", OWNER="${user}", GROUP="${group}", MODE="${mode}"
      '';
    })

    # /dev/sev-guest
    (mkIf cfgSevGuest.enable {
      assertions = [
        {
          assertion = hasAttr cfgSevGuest.user config.users.users;
          message = "Given user does not exist";
        }
        {
          assertion = (cfgSevGuest.group == options.hardware.cpu.amd.sevGuest.group.default) || (hasAttr cfgSevGuest.group config.users.groups);
          message = "Given group does not exist";
        }
      ];

      users.groups = optionalAttrs (cfgSevGuest.group == options.hardware.cpu.amd.sevGuest.group.default) {
        "${cfgSevGuest.group}" = { };
      };

      services.udev.extraRules = with cfgSevGuest; ''
        KERNEL=="sev-guest", OWNER="${user}", GROUP="${group}", MODE="${mode}"
      '';
    })
  ];
}
