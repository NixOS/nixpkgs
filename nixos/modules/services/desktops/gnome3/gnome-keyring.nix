# GNOME Keyring daemon.

{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.gnome3.gnome-keyring;
in

{

  ###### interface

  options = {

    services.gnome3.gnome-keyring = {

      enable = mkEnableOption "gnome-keyring";

      enableService = mkEnableOption "gnome-keyring-daemon" // {
        description = ''
          Whether to run a systemd service which runs the keyring daemon.

          This is enabled by default if `services.gnome3.gnome-keyring.enable = true` and
          the gnome3 DE is not enabled. If gnome3 is enabled, it will take care of the keyring daemon and this
          option can be `false`.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.gnome3.gnome-keyring ];

    services.dbus.packages = [ pkgs.gnome3.gnome-keyring pkgs.gnome3.gcr ];

    services.gnome3.gnome-keyring.enableService = mkDefault (!config.services.xserver.desktopManager.gnome3.enable);

    systemd.user.services.gnome-keyring-daemon = mkIf cfg.enableService {
      description = "Runs the gnome-keyring daemon";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];

      serviceConfig = {
        Restart = "always";
        ExecStart = "${pkgs.gnome3.gnome-keyring}/bin/gnome-keyring-daemon -f";
      };
    };

  };

}
