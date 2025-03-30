{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.programs.gphoto2;
  opt = options.programs.gphoto2;
in
{
  meta.maintainers = [ lib.maintainers.league ];

  ###### interface
  options = {
    programs.gphoto2 = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to configure system to use gphoto2.";
      };
      group = lib.mkOption {
        description = ''
          Group created when gphoto2 is enabled.

          To grant digital camera access to a user, the user must be part of this group:
          `users.users.alice.extraGroups = [ config.programs.gphoto2.group ];`.
        '';
        type = lib.types.str;
        default = cfg.libgphoto2Package.group;
        defaultText = lib.literalExpression "config.programs.gphoto2.libgphoto2Package.group";
        readOnly = true;
      };
      libgphoto2Package = lib.mkPackageOption pkgs "libgphoto2" { };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.udev.packages = [ opt.libgphoto2Package.default ];
    environment.systemPackages = [ pkgs.gphoto2 ];
    users.groups."${cfg.group}" = { };
  };
}
