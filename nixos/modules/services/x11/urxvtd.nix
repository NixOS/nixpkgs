{ config, lib, pkgs, ... }:

# maintainer: siddharthist

with lib;

let
  cfg = config.services.urxvtd;
in {

  options.services.urxvtd.enable = mkOption {
    type = types.bool;
    default = false;
    description = ''
      Enable urxvtd, the urxvt terminal daemon. To use urxvtd, run
      "urxvtc".
    '';
  };

  config = mkIf cfg.enable {
    systemd.user = {
      sockets.urxvtd = {
        description = "socket for urxvtd, the urxvt terminal daemon";
        after = [ "graphical.target" ];
        wants = [ "graphical.target" ];
        wantedBy = [ "sockets.target" ];
        socketConfig = {
          ListenStream = "%t/urxvtd-socket";
        };
      };

      services.urxvtd = {
        description = "urxvt terminal daemon";
        path = [ pkgs.xsel ];
        serviceConfig = {
          ExecStart = "${pkgs.rxvt_unicode-with-plugins}/bin/urxvtd -o";
          Environment = "RXVT_SOCKET=%t/urxvtd-socket";
          Restart = "on-failure";
          RestartSec = "5s";
        };
      };

    };

    environment.systemPackages = [ pkgs.rxvt_unicode-with-plugins ];
    environment.variables.RXVT_SOCKET = "/run/user/$(id -u)/urxvtd-socket";
  };

}
