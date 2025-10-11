{
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.hardware.stlink;
  opt = options.hardware.stlink;
in
{
  options.hardware.stlink = {
    enable = lib.mkEnableOption "udev rules for ST-Link programmer devices";
    owner = lib.mkOption {
      type = lib.types.str;
      default = "root";
      example = "nobody";
      description = "Owner of ST-Link devices";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "plugdev";
      example = "nobody";
      description = "Group of ST-Link devices";
    };
    mode = lib.mkOption {
      type = lib.types.str;
      default = "0660";
      example = "0640";
      description = "Mode of ST-Link devices";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = builtins.hasAttr cfg.owner config.users.users;
          message = "Owner '${cfg.owner}' set in `${opt.owner}` is not configured via `${options.users.users}.\"${cfg.owner}\"`.";
        }
        {
          assertion = (cfg.group == opt.group.default) || (builtins.hasAttr cfg.group config.users.groups);
          message = "Group '${cfg.group}' set in `${opt.group}` is not configured via `${options.users.groups}.\"${cfg.group}\"`.";
        }
      ];
      # Source: https://www.linux-usb.org/usb.ids
      services.udev.extraRules = ''
        # ST-Link V1
        SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3744", OWNER="${cfg.owner}", GROUP="${cfg.group}", MODE="${cfg.mode}"

        # ST-Link V2
        SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3748", OWNER="${cfg.owner}", GROUP="${cfg.group}", MODE="${cfg.mode}"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3752", OWNER="${cfg.owner}", GROUP="${cfg.group}", MODE="${cfg.mode}"

        # ST-Link V2.1
        SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374b", OWNER="${cfg.owner}", GROUP="${cfg.group}", MODE="${cfg.mode}"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3752", OWNER="${cfg.owner}", GROUP="${cfg.group}", MODE="${cfg.mode}"

        # ST-Link V3
        SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374e", OWNER="${cfg.owner}", GROUP="${cfg.group}", MODE="${cfg.mode}"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374f", OWNER="${cfg.owner}", GROUP="${cfg.group}", MODE="${cfg.mode}"
        SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3753", OWNER="${cfg.owner}", GROUP="${cfg.group}", MODE="${cfg.mode}"
        # ST-Link V3 Loader (what is this?)
        SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374d", OWNER="${cfg.owner}", GROUP="${cfg.group}", MODE="${cfg.mode}"
      '';
      users.groups.plugdev = lib.mkIf (config.group == "plugdev") { };
    })
  ];

  meta.maintainers = with lib.maintainers; [ pandapip1 ];
}
