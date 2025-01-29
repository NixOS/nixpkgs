{ config, lib, pkgs, ... }:
let
  cfg = config.services.etesync-dav;
in
  {
    options.services.etesync-dav = {
      enable = lib.mkEnableOption "etesync-dav, end-to-end encrypted sync for contacts, calendars and tasks";

      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "The server host address.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 37358;
        description = "The server host port.";
      };

      apiUrl = lib.mkOption {
        type = lib.types.str;
        default = "https://api.etebase.com/partner/etesync/";
        description = "The url to the etesync API.";
      };

      openFirewall = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Whether to open the firewall for the specified port.";
      };

      sslCertificate = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/etesync.crt";
        description = ''
          Path to server SSL certificate. It will be copied into
          etesync-dav's data directory.
        '';
      };

      sslCertificateKey = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/etesync.key";
        description = ''
          Path to server SSL certificate key.  It will be copied into
          etesync-dav's data directory.
        '';
      };
    };

    config = lib.mkIf cfg.enable {
      networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

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
          ExecStartPre = lib.mkIf (cfg.sslCertificate != null || cfg.sslCertificateKey != null) (
            pkgs.writers.writeBash "etesync-dav-copy-keys" ''
              ${lib.optionalString (cfg.sslCertificate != null) ''
                cp ${toString cfg.sslCertificate} $STATE_DIRECTORY/etesync.crt
              ''}
              ${lib.optionalString (cfg.sslCertificateKey != null) ''
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
