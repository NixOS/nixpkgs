{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.xserver.windowManager.wmii;
  wmii = pkgs.wmii_hg;
in
{
  options = {
    services.xserver.windowManager.wmii.enable = mkEnableOption (lib.mdDoc "wmii");
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton
      # stop wmii by
      #   $wmiir xwrite /ctl quit
      # this will cause wmii exiting with exit code 0
      # (or "mod+a quit", which is bound to do the same thing in wmiirc
      # by default)
      #
      # why this loop?
      # wmii crashes once a month here. That doesn't matter that much
      # wmii can recover very well. However without loop the X session
      # terminates and then your workspace setup is lost and all
      # applications running on X will terminate.
      # Another use case is kill -9 wmii; after rotating screen.
      # Note: we don't like kill for that purpose. But it works (->
      # subject "wmii and xrandr" on mailinglist)
      { name = "wmii";
        start = ''
          while :; do
            ${wmii}/bin/wmii && break
          done
        '';
      };

    environment.systemPackages = [ wmii ];
  };
}
