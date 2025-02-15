{
  lib,
  config,
  options,
  ...
}:
let
  cfg = config.hardware.freejoy;
  opt = options.hardware.freejoy;
in
{
  options.hardware.stlink = {
    enable = lib.mkEnableOption "udev rules for FreeJoy USB devices";
    owner = lib.mkOption {
      type = lib.types.str;
      default = "root";
      example = "nobody";
      description = "Owner of FreeJoy devices";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "plugdev";
      example = "nobody";
      description = "Group of FreeJoy devices";
    };
    mode = lib.mkOption {
      type = lib.types.str;
      default = "0660";
      example = "0640";
      description = "Mode of FreeJoy devices";
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
      services.udev.extraRules = ''
        ENV{ID_VENDOR}=="FreeJoy", OWNER="${cfg.owner}", GROUP="${cfg.group}", MODE="${cfg.mode}"
      '';
      users.groups.plugdev = lib.mkIf (config.group == "plugdev") { };
    })
  ];

  meta.maintainers = with lib.maintainers; [ pandapip1 ];
}
