{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.throttled;
in {
  options = {
    services.throttled = {
      enable = mkEnableOption "fix for Intel CPU throttling";
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ pkgs.throttled ];
    # The upstream package has this in Install, but that's not enough, see the NixOS manual
    systemd.services."lenovo_fix".wantedBy = [ "multi-user.target" ];

    environment.etc."lenovo_fix.conf".source = "${pkgs.throttled}/etc/lenovo_fix.conf";
  };
}
