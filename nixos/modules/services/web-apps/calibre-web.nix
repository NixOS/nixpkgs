{ config, lib, pkgs, ... }:

let
  cfg = config.services.calibre-web;
in
{
  options = {
    services.calibre-web = {
      enable = lib.mkEnableOption "Calibre-Web";

      package = lib.mkPackageOption pkgs "calibre-web" { };

      listen = {
        ip = lib.mkOption {
          type = lib.types.str;
          default = "::1";
          description = ''
            IP address that Calibre-Web should listen on.
          '';
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 8083;
          description = ''
            Listen port for Calibre-Web.
          '';
        };
      };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "calibre-web";
        description = ''
          The directory below {file}`/var/lib` where Calibre-Web stores its data.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "calibre-web";
        description = "User account under which Calibre-Web runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "calibre-web";
        description = "Group account under which Calibre-Web runs.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the server.
        '';
      };

      options = {
        calibreLibrary = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = ''
            Path to Calibre library.
          '';
        };

        enableBookConversion = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Configure path to the Calibre's ebook-convert in the DB.
          '';
        };

        enableKepubify = lib.mkEnableOption "kebup conversion support";

        enableBookUploading = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Allow books to be uploaded via Calibre-Web UI.
          '';
        };

        reverseProxyAuth = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = ''
              Enable authorization using auth proxy.
            '';
          };

          header = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = ''
              Auth proxy header name.
            '';
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.calibre-web = let
      appDb = "/var/lib/${cfg.dataDir}/app.db";
      gdriveDb = "/var/lib/${cfg.dataDir}/gdrive.db";
      calibreWebCmd = "${cfg.package}/bin/calibre-web -p ${appDb} -g ${gdriveDb}";

      settings = lib.concatStringsSep ", " (
        [
          "config_port = ${toString cfg.listen.port}"
          "config_uploading = ${if cfg.options.enableBookUploading then "1" else "0"}"
          "config_allow_reverse_proxy_header_login = ${if cfg.options.reverseProxyAuth.enable then "1" else "0"}"
          "config_reverse_proxy_login_header_name = '${cfg.options.reverseProxyAuth.header}'"
        ]
        ++ lib.optional (cfg.options.calibreLibrary != null) "config_calibre_dir = '${cfg.options.calibreLibrary}'"
        ++ lib.optional cfg.options.enableBookConversion "config_converterpath = '${pkgs.calibre}/bin/ebook-convert'"
        ++ lib.optional cfg.options.enableKepubify "config_kepubifypath = '${pkgs.kepubify}/bin/kepubify'"
      );
    in
      {
        description = "Web app for browsing, reading and downloading eBooks stored in a Calibre database";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;

          StateDirectory = cfg.dataDir;
          ExecStartPre = pkgs.writeShellScript "calibre-web-pre-start" (
            ''
              __RUN_MIGRATIONS_AND_EXIT=1 ${calibreWebCmd}

              ${pkgs.sqlite}/bin/sqlite3 ${appDb} "update settings set ${settings}"
            '' + lib.optionalString (cfg.options.calibreLibrary != null) ''
              test -f "${cfg.options.calibreLibrary}/metadata.db" || { echo "Invalid Calibre library"; exit 1; }
            ''
          );

          ExecStart = "${calibreWebCmd} -i ${cfg.listen.ip}";
          Restart = "on-failure";
        };
      };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listen.port ];
    };

    users.users = lib.mkIf (cfg.user == "calibre-web") {
      calibre-web = {
        isSystemUser = true;
        group = cfg.group;
      };
    };

    users.groups = lib.mkIf (cfg.group == "calibre-web") {
      calibre-web = {};
    };
  };

  meta.maintainers = with lib.maintainers; [ pborzenkov ];
}
