{ config, lib, pkgs, ... }:

with lib;

{
  meta.maintainers = [ maintainers.league ];

  ###### interface
  options = {
    programs.gphoto2 = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to configure system to use gphoto2.
          To grant digital camera access to a user, the user must
          be part of the camera group:
          <code>users.extraUsers.alice.extraGroups = ["camera"];</code>
        '';
      };
    };
  };

  ###### implementation
  config = mkIf config.programs.gphoto2.enable {
    services.udev.packages = [ pkgs.libgphoto2 ];
    environment.systemPackages = [ pkgs.gphoto2 ];
    users.extraGroups.camera = {};
  };
}
