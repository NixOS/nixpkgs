{
  config,
  options,
  lib,
  ...
}:
let
  cfgSev = config.hardware.cpu.amd.sev;
  cfgSevGuest = config.hardware.cpu.amd.sevGuest;

  optionsFor = device: group: {
    enable = lib.mkEnableOption "access to the AMD ${device} device";
    user = lib.mkOption {
      description = "Owner to assign to the ${device} device.";
      type = lib.types.str;
      default = "root";
    };
    group = lib.mkOption {
      description = "Group to assign to the ${device} device.";
      type = lib.types.str;
      default = group;
    };
    mode = lib.mkOption {
      description = "Mode to set for the ${device} device.";
      type = lib.types.str;
      default = "0660";
    };
  };
in
with lib;
{
  options.hardware.cpu.amd.sev = optionsFor "SEV" "sev";

  options.hardware.cpu.amd.sevGuest = optionsFor "SEV guest" "sev-guest";

  config = lib.mkMerge [
    # /dev/sev
    (lib.mkIf cfgSev.enable {
      assertions = [
        {
          assertion = lib.hasAttr cfgSev.user config.users.users;
          message = "Given user does not exist";
        }
        {
          assertion =
            (cfgSev.group == options.hardware.cpu.amd.sev.group.default)
            || (lib.hasAttr cfgSev.group config.users.groups);
          message = "Given group does not exist";
        }
      ];

      boot.extraModprobeConfig = ''
        options kvm_amd sev=1
      '';

      users.groups = lib.optionalAttrs (cfgSev.group == options.hardware.cpu.amd.sev.group.default) {
        "${cfgSev.group}" = { };
      };

      services.udev.extraRules = with cfgSev; ''
        KERNEL=="sev", OWNER="${user}", GROUP="${group}", MODE="${mode}"
      '';
    })

    # /dev/sev-guest
    (lib.mkIf cfgSevGuest.enable {
      assertions = [
        {
          assertion = lib.hasAttr cfgSevGuest.user config.users.users;
          message = "Given user does not exist";
        }
        {
          assertion =
            (cfgSevGuest.group == options.hardware.cpu.amd.sevGuest.group.default)
            || (lib.hasAttr cfgSevGuest.group config.users.groups);
          message = "Given group does not exist";
        }
      ];

      users.groups =
        lib.optionalAttrs (cfgSevGuest.group == options.hardware.cpu.amd.sevGuest.group.default)
          {
            "${cfgSevGuest.group}" = { };
          };

      services.udev.extraRules = with cfgSevGuest; ''
        KERNEL=="sev-guest", OWNER="${user}", GROUP="${group}", MODE="${mode}"
      '';
    })
  ];
}
