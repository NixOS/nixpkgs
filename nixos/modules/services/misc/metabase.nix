{ config, lib, pkgs, ... }:

let
  cfg = config.services.metabase;

  inherit (lib) mkEnableOption mkIf mkOption;
  inherit (lib) optional optionalAttrs types;

  dataDir = "/var/lib/metabase";

in {

  options = {

    services.metabase = {
      enable = mkEnableOption "Metabase service";

      listen = {
        ip = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = lib.mdDoc ''
            IP address that Metabase should listen on.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 3000;
          description = lib.mdDoc ''
            Listen port for Metabase.
          '';
        };
      };

      ssl = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            Whether to enable SSL (https) support.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 8443;
          description = lib.mdDoc ''
            Listen port over SSL (https) for Metabase.
          '';
        };

        keystore = mkOption {
          type = types.nullOr types.path;
          default = "${dataDir}/metabase.jks";
          example = "/etc/secrets/keystore.jks";
          description = lib.mdDoc ''
            [Java KeyStore](https://www.digitalocean.com/community/tutorials/java-keytool-essentials-working-with-java-keystores) file containing the certificates.
          '';
        };

      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open ports in the firewall for Metabase.
        '';
      };
    };

  };

  config = mkIf cfg.enable {

    systemd.services.metabase = {
      description = "Metabase server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      environment = {
        MB_PLUGINS_DIR = "${dataDir}/plugins";
        MB_DB_FILE = "${dataDir}/metabase.db";
        MB_JETTY_HOST = cfg.listen.ip;
        MB_JETTY_PORT = toString cfg.listen.port;
      } // optionalAttrs (cfg.ssl.enable) {
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

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listen.port ] ++ optional cfg.ssl.enable cfg.ssl.port;
    };

  };
}
