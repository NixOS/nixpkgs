{ config, lib, pkgs, ... }:

let
  cfg = config.services.metabase;

  inherit (lib) mkEnableOption mkIf lib.mkOption;
  inherit (lib) lib.optional lib.optionalAttrs types;

  dataDir = "/var/lib/metabase";

in {

  options = {

    services.metabase = {
      enable = lib.mkEnableOption "Metabase service";

      listen = {
        ip = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = ''
            IP address that Metabase should listen on.
          '';
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 3000;
          description = ''
            Listen port for Metabase.
          '';
        };
      };

      ssl = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to enable SSL (https) support.
          '';
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 8443;
          description = ''
            Listen port over SSL (https) for Metabase.
          '';
        };

        keystore = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = "${dataDir}/metabase.jks";
          example = "/etc/secrets/keystore.jks";
          description = ''
            [Java KeyStore](https://www.digitalocean.com/community/tutorials/java-keytool-essentials-working-with-java-keystores) file containing the certificates.
          '';
        };

      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for Metabase.
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {

    systemd.services.metabase = {
      description = "Metabase server";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      environment = {
        MB_PLUGINS_DIR = "${dataDir}/plugins";
        MB_DB_FILE = "${dataDir}/metabase.db";
        MB_JETTY_HOST = cfg.listen.ip;
        MB_JETTY_PORT = toString cfg.listen.port;
      } // lib.optionalAttrs (cfg.ssl.enable) {
        MB_JETTY_SSL = true;
        MB_JETTY_SSL_PORT = toString cfg.ssl.port;
        MB_JETTY_SSL_KEYSTORE = cfg.ssl.keystore;
      };
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = baseNameOf dataDir;
        ExecStart = "${pkgs.metabase}/bin/metabase";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listen.port ] ++ lib.optional cfg.ssl.enable cfg.ssl.port;
    };

  };
}
