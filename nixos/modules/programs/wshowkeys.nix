{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.wshowkeys;
in {
  meta.maintainers = with maintainers; [ primeos ];

  options = {
    programs.wshowkeys = {
      enable = mkEnableOption (lib.mdDoc ''
        wshowkeys (displays keypresses on screen on supported Wayland
        compositors). It requires root permissions to read input events, but
        these permissions are dropped after startup'');
    };
  };

  config = mkIf cfg.enable {
    security.wrappers.wshowkeys =
      { setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.wshowkeys}/bin/wshowkeys";
      };
  };
}
