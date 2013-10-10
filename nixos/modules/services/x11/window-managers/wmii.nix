{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.xserver.windowManager.wmii;

in

{
  options = {

    services.xserver.windowManager.wmii.enable = mkOption {
      default = false;
      example = true;
      description = "Enable the wmii window manager.";
    };

  };

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      # stop wmii by
      #   $wmiir xwrite /ctl quit
      # this will cause wmii exiting with exit code 0
      #
      # why this loop?
      # wmii crashes once a month here. That doesn't matter that much
      # wmii can recover very well. However without loop the x session terminates and then your workspace setup is
      # lost and all applications running on X will terminate.
      # Another use case is kill -9 wmii; after rotating screen.
      # Note: we don't like kill for that purpose. But it works (-> subject "wmii and xrandr" on mailinglist)
      { name = "wmii";
        start = ''
          while :; do
            ${pkgs.wmiiSnap}/bin/wmii && break
          done
        '';
      };

    environment.systemPackages = [ pkgs.wmiiSnap ];

  };

}
