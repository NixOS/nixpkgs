{ config, lib, pkgs, ... }:

with lib;

{
  meta.maintainers = [ maintainers.mic92 ];

  ###### interface
  options = {
    programs.adb = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to configure system to use Android Debug Bridge (adb).
          To grant access to a user, it must be part of adbusers group:
          <code>users.users.alice.extraGroups = ["adbusers"];</code>
        '';
      };
    };
  };

  ###### implementation
  config = mkIf config.programs.adb.enable {
    services.udev.packages = [ pkgs.android-udev-rules ];
    # Give platform-tools lower priority so mke2fs+friends are taken from other packages first
    environment.systemPackages = [ (lowPrio pkgs.androidenv.androidPkgs_9_0.platform-tools) ];
    users.groups.adbusers = {};
  };
}
