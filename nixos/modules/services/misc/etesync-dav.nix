{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.etesync-dav;
in
  {
    options.services.etesync-dav = {
      enable = mkEnableOption "etesync-dav, end-to-end encrypted sync for contacts, calendars and tasks";

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "The server host address.";
      };

      port = mkOption {
        type = types.port;
        default = 37358;
        description = "The server host port.";
      };

      apiUrl = mkOption {
        type = types.str;
        default = "https://api.etesync.com/";
        description = "The url to the etesync API.";
      };

      openFirewall = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to open the firewall for the specified port.";
      };

      sslCertificate = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/etesync.crt";
        description = ''
          Path to server SSL certificate. It will be copied into
          etesync-dav's data directory.
        '';
      };

      sslCertificateKey = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/etesync.key";
        description = ''
          Path to server SSL certificate key.  It will be copied into
          etesync-dav's data directory.
        '';
      };
    };

    config = mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

      systemd.services.etesync-dav = {
        description = "etesync-dav - A CalDAV and CardDAV adapter for EteSync";
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.etesync-dav ];
        environment = {
          ETESYNC_LISTEN_ADDRESS = cfg.host;
          ETESYNC_LISTEN_PORT = toString cfg.port;
          ETESYNC_URL = cfg.apiUrl;
          ETESYNC_DATA_DIR = "/var/lib/etesync-dav";
        };

        serviceConfig = {
          Type = "simple";
          DynamicUser = true;
          StateDirectory = "etesync-dav";
          ExecStart = "${pkgs.etesync-dav}/bin/etesync-dav";
          ExecStartPre = mkIf (cfg.sslCertificate != null || cfg.sslCertificateKey != null) (
            pkgs.writers.writeBash "etesync-dav-copy-keys" ''
              ${optionalString (cfg.sslCertificate != null) ''
                cp ${toString cfg.sslCertificate} $STATE_DIRECTORY/etesync.crt
              ''}
              ${optionalString (cfg.sslCertificateKey != null) ''
                cp ${toString cfg.sslCertificateKey} $STATE_DIRECTORY/etesync.key
              ''}
            ''
          );
          Restart = "on-failure";
          RestartSec = "30min 1s";
        };
      };
    };
  }
