{ config, lib, pkgs, ... }:
let cfg = config.programs.yubikey-touch-detector;
in {
  options = {
    programs.yubikey-touch-detector = {
      enable = lib.mkEnableOption "yubikey-touch-detector";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ pkgs.yubikey-touch-detector ];

    systemd.user.services.yubikey-touch-detector = {
      path = [ pkgs.gnupg ];
      wantedBy = [ "graphical-session.target" ];
    };
    systemd.user.sockets.yubikey-touch-detector = {
      wantedBy = [ "sockets.target" ];
    };
  };
}
