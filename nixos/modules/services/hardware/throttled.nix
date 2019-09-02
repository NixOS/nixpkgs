{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.throttled;
in {
  options = {
    services.throttled = {
      enable = mkEnableOption "fix for Intel CPU throttling";

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Alternative configuration";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.packages = [ pkgs.throttled ];
    # The upstream package has this in Install, but that's not enough, see the NixOS manual
    systemd.services."lenovo_fix".wantedBy = [ "multi-user.target" ];

    environment.etc."lenovo_fix.conf".source =
      if cfg.extraConfig != ""
      then pkgs.writeText "lenovo_fix.conf" cfg.extraConfig
      else "${pkgs.throttled}/etc/lenovo_fix.conf";
  };
}
