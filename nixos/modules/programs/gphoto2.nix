{
  config,
  lib,
  pkgs,
  ...
}:

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
        default = "camera";
        example = "gphoto2";
      };
    };
  };

  ###### implementation
  config = lib.mkIf config.programs.gphoto2.enable {
    services.udev.packages = [ pkgs.libgphoto2 ];
    environment.systemPackages = [ pkgs.gphoto2 ];
    users.groups."${config.programs.gphoto2.group}" = { };
  };
}
