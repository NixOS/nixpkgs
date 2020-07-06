{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.dropbox;

in

{
  ###### interface

  options.services.dropbox = {

    enable = mkEnableOption ''
      Whether to enable the dropbox service globally.
    '';

    install = mkEnableOption ''
      Whether to install a user service for the dropbox daemon. Once
      the service is started, the Dropbox desktop app is available.

      The service must be manually started for each user with
      "systemctl --user start dropbox" or globally through
      <varname>services.dropbox.enable</varname>.
    '';

    openFirewall = mkEnableOption ''
      Open ports in the firewall for Dropbox.

      UDP: 17500
      TCP: 17500
    '';

  };

  ###### implementation

  config = mkIf (cfg.enable || cfg.install) {

    environment.systemPackages = with pkgs; [ dropbox-cli ];

    systemd.user.services.dropbox = {
      description = "Dropbox daemon";
      after = [ "xembedsniproxy.service" ];
      wants = [ "xembedsniproxy.service" ];
      environment = {
        QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
        QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
      };
      serviceConfig = {
        ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
        ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
        KillMode = "control-group"; # upstream recommends process
        Restart = "on-failure";
        PrivateTmp = true;
        ProtectSystem = "full";
        Nice = 10;
      };
    } // optionalAttrs cfg.enable {
      wantedBy = [ "graphical-session.target" ];
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ 17500 ];
      allowedUDPPorts = [ 17500 ];
    };

  };

  meta.maintainers = with lib.maintainers; [ romildo ];

}
