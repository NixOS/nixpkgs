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

<<<<<<< HEAD
    systemd.services.set-cfs-tweaks.wantedBy = [
      "multi-user.target"
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];
=======
    systemd.services.set-cfs-tweak.wantedBy = [ "multi-user.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
