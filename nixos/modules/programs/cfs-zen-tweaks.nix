# CFS Zen Tweaks

{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs.cfs-zen-tweaks;

in

{

  meta = {
    maintainers = with maintainers; [ mkg20001 ];
  };

  options = {
    programs.cfs-zen-tweaks.enable = mkEnableOption (lib.mdDoc "CFS Zen Tweaks");
  };

  config = mkIf cfg.enable {
    systemd.packages = [ pkgs.cfs-zen-tweaks ];

    systemd.services.set-cfs-tweak.wantedBy = [ "multi-user.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
  };
}
