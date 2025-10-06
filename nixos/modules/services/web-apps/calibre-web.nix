{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.calibre-web;
  dataDir = if lib.hasPrefix "/" cfg.dataDir then cfg.dataDir else "/var/lib/${cfg.dataDir}";

  inherit (lib)
    concatStringsSep
    mkEnableOption
    mkIf
    mkOption
    optional
    optionals
    optionalString
    types
    ;
in
{
  options = {
    services.calibre-web = {
      enable = mkEnableOption "Calibre-Web";

      package = lib.mkPackageOption pkgs "calibre-web" { };

      listen = {
        ip = mkOption {
          type = types.str;
          default = "::1";
          description = ''
            IP address that Calibre-Web should listen on.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 8083;
          description = ''
            Listen port for Calibre-Web.
          '';
        };
      };

      dataDir = mkOption {
        type = types.str;
        default = "calibre-web";
        description = ''
          Where Calibre-Web stores its data.
          Either an absolute path, or the directory name below {file}`/var/lib`.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "calibre-web";
        description = "User account under which Calibre-Web runs.";
      };

      group = mkOption {
        type = types.str;
        default = "calibre-web";
        description = "Group account under which Calibre-Web runs.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the server.
        '';
      };

      options = {
        calibreLibrary = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            Path to Calibre library.
          '';
        };

        enableBookConversion = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Configure path to the Calibre's ebook-convert in the DB.
          '';
        };

        enableKepubify = mkEnableOption "kebup conversion support";

        enableBookUploading = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Allow books to be uploaded via Calibre-Web UI.
          '';
        };

        reverseProxyAuth = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enable authorization using auth proxy.
            '';
          };

          header = mkOption {
            type = types.str;
            default = "";
            description = ''
              Auth proxy header name.
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.settings = lib.optionalAttrs (lib.hasPrefix "/" cfg.dataDir) {
      "10-calibre-web".${dataDir}.d = {
        inherit (cfg) user group;
        mode = "0700";
      };
    };

    systemd.services.calibre-web =
      let
        appDb = "${dataDir}/app.db";
        gdriveDb = "${dataDir}/gdrive.db";
        calibreWebCmd = "${cfg.package}/bin/calibre-web -p ${appDb} -g ${gdriveDb}";

        settings = concatStringsSep ", " (
          [
            "config_port = ${toString cfg.listen.port}"
            "config_uploading = ${if cfg.options.enableBookUploading then "1" else "0"}"
            "config_allow_reverse_proxy_header_login = ${
              if cfg.options.reverseProxyAuth.enable then "1" else "0"
            }"
            "config_reverse_proxy_login_header_name = '${cfg.options.reverseProxyAuth.header}'"
          ]
          ++ optional (
            cfg.options.calibreLibrary != null
          ) "config_calibre_dir = '${cfg.options.calibreLibrary}'"
          ++ optionals cfg.options.enableBookConversion [
            "config_converterpath = '${pkgs.calibre}/bin/ebook-convert'"
            "config_binariesdir = '${pkgs.calibre}/bin/'"
          ]
          ++ optional cfg.options.enableKepubify "config_kepubifypath = '${pkgs.kepubify}/bin/kepubify'"
        );
      in
      {
        description = "Web app for browsing, reading and downloading eBooks stored in a Calibre database";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        # fix book cover cache directory defaults to a path under /nix/store/
        environment.CACHE_DIR = "/var/cache/calibre-web";

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;

          ExecStartPre = pkgs.writeShellScript "calibre-web-pre-start" (
            ''
              __RUN_MIGRATIONS_AND_EXIT=1 ${calibreWebCmd}

              ${pkgs.sqlite}/bin/sqlite3 ${appDb} "update settings set ${settings}"
            ''
            + optionalString (cfg.options.calibreLibrary != null) ''
              test -f "${cfg.options.calibreLibrary}/metadata.db" || { echo "Invalid Calibre library"; exit 1; }
            ''
          );

          ExecStart = "${calibreWebCmd} -i ${cfg.listen.ip}";
          Restart = "on-failure";

          CacheDirectory = "calibre-web";
          CacheDirectoryMode = "0750";
        }
        // lib.optionalAttrs (!(lib.hasPrefix "/" cfg.dataDir)) {
          StateDirectory = cfg.dataDir;
        };
      };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listen.port ];
    };

    users.users = mkIf (cfg.user == "calibre-web") {
      calibre-web = {
        isSystemUser = true;
        group = cfg.group;
      };
    };

    users.groups = mkIf (cfg.group == "calibre-web") {
      calibre-web = { };
    };
  };

  meta.maintainers = with lib.maintainers; [ pborzenkov ];
}
