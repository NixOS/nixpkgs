{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.programs.dotool;
in
{
  meta.maintainers = with lib.maintainers; [ dtomvan ];

  options.programs.dotool = {
    enable = lib.mkEnableOption "Simulate keyboard/mouse with dotool";
    allowedUsers = lib.mkOption {
      description = "List of users which are allowed to use dotool without root permissions";
      type = with lib.types; listOf (passwdEntry str);
      default = [ ];
      example = [ "alice" ];
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.uinput.enable = true;
    environment.systemPackages = [ pkgs.dotool ];
    services.udev.packages = [ pkgs.dotool-udev-rules ];
    # in theory the dotool-udev-rules allows any user in input to use rootless
    # dotool, but in practice is the /dev/uinput gated behind the uinput group
    users.groups.input.members = cfg.allowedUsers;
    users.groups.uinput.members = cfg.allowedUsers;
  };
}
