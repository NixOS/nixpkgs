{ config, lib, pkgs, ... }:

with lib;

let
  defaultGroup = "camera";
in
{
  meta.maintainers = [ maintainers.league ];

  ###### interface
  options = {
    programs.gphoto2 = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Whether to configure system to use gphoto2.";
      };
      group = lib.mkOption {
        description = lib.mdDoc ''
          Group created when gphoto2 is enabled.

          To grant digital camera access to a user, the user must be part of this group:
          `users.users.alice.extraGroups = [config.programs.gphoto2.group];`.

          By default, a group named `${defaultGroup}` will be created.
        '';
        type = lib.types.str;
        default = defaultGroup;
        example = "gphoto2";
      };
    };
  };

  ###### implementation
  config = mkIf config.programs.gphoto2.enable {
    services.udev.packages = [ pkgs.libgphoto2 ];
    environment.systemPackages = [ pkgs.gphoto2 ];
    users.groups."${config.programs.gphoto2.group}" = {};
  };
}
