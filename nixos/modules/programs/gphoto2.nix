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
        description = ''
          Whether to configure system to use gphoto2.
          To grant digital camera access to a user, the user must
          be part of the camera group:
          `users.users.alice.extraGroups = ["camera"];`
        '';
      };
    };
  };

  ###### implementation
  config = lib.mkIf config.programs.gphoto2.enable {
    services.udev.packages = [ pkgs.libgphoto2 ];
    environment.systemPackages = [ pkgs.gphoto2 ];
    users.groups.camera = { };
  };
}
