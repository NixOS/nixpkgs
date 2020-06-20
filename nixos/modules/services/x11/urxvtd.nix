{ config, lib, pkgs, ... }:

# maintainer: siddharthist

with lib;

let
  cfg = config.services.urxvtd;
in {
  options.services.urxvtd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable urxvtd, the urxvt terminal daemon. To use urxvtd, run
        "urxvtc".
      '';
    };

    package = mkOption {
      default = pkgs.rxvt-unicode;
      defaultText = "pkgs.rxvt-unicode";
      description = ''
        Package to install. Usually pkgs.rxvt-unicode.
      '';
      type = types.package;
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.urxvtd = {
      description = "urxvt terminal daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      path = [ pkgs.xsel ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/urxvtd -o";
        Environment = "RXVT_SOCKET=%t/urxvtd-socket";
        Restart = "on-failure";
        RestartSec = "5s";
      };
    };

    environment.systemPackages = [ cfg.package ];
    environment.variables.RXVT_SOCKET = "/run/user/$(id -u)/urxvtd-socket";
  };

  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

}
