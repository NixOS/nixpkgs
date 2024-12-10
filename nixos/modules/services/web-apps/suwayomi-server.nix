{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.suwayomi-server;
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    ;

  format = pkgs.formats.hocon { };
in
{
  options = {
    services.suwayomi-server = {
      enable = mkEnableOption "Suwayomi, a free and open source manga reader server that runs extensions built for Tachiyomi.";

      package = lib.mkPackageOptionMD pkgs "suwayomi-server" { };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/suwayomi-server";
        example = "/var/data/mangas";
        description = ''
          The path to the data directory in which Suwayomi-Server will download scans.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "suwayomi";
        example = "root";
        description = ''
          User account under which Suwayomi-Server runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "suwayomi";
        example = "medias";
        description = ''
          Group under which Suwayomi-Server runs.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the firewall for the port in {option}`services.suwayomi-server.settings.server.port`.
        '';
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = format.type;
          options = {
            server = {
              ip = mkOption {
                type = types.str;
                default = "0.0.0.0";
                example = "127.0.0.1";
                description = ''
                  The ip that Suwayomi will bind to.
                '';
              };

              port = mkOption {
                type = types.port;
                default = 8080;
                example = 4567;
                description = ''
                  The port that Suwayomi will listen to.
                '';
              };

              basicAuthEnabled = mkEnableOption ''
                Add basic access authentication to Suwayomi-Server.
                Enabling this option is useful when hosting on a public network/the Internet
              '';

              basicAuthUsername = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = ''
                  The username value that you have to provide when authenticating.
                '';
              };

              # NOTE: this is not a real upstream option
              basicAuthPasswordFile = mkOption {
                type = types.nullOr types.path;
                default = null;
                example = "/var/secrets/suwayomi-server-password";
                description = ''
                  The password file containing the value that you have to provide when authenticating.
                '';
              };

              downloadAsCbz = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Download chapters as `.cbz` files.
                '';
              };

              extensionRepos = mkOption {
                type = types.listOf types.str;
                default = [ ];
                example = [
                  "https://raw.githubusercontent.com/MY_ACCOUNT/MY_REPO/repo/index.min.json"
                ];
                description = ''
                  URL of repositories from which the extensions can be installed.
                '';
              };

              localSourcePath = mkOption {
                type = types.path;
                default = cfg.dataDir;
                defaultText = lib.literalExpression "suwayomi-server.dataDir";
                example = "/var/data/local_mangas";
                description = ''
                  Path to the local source folder.
                '';
              };

              systemTrayEnabled = mkOption {
                type = types.bool;
                default = false;
                description = ''
                  Whether to enable a system tray icon, if possible.
                '';
              };
            };
          };
        };
        description = ''
          Configuration to write to {file}`server.conf`.
          See <https://github.com/Suwayomi/Suwayomi-Server/wiki/Configuring-Suwayomi-Server> for more information.
        '';
        default = { };
        example = {
          server.socksProxyEnabled = true;
          server.socksProxyHost = "yourproxyhost.com";
          server.socksProxyPort = "8080";
        };
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion =
          with cfg.settings.server;
          basicAuthEnabled -> (basicAuthUsername != null && basicAuthPasswordFile != null);
        message = ''
          [suwayomi-server]: the username and the password file cannot be null when the basic auth is enabled
        '';
      }
    ];

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.server.port ];

    users.groups = mkIf (cfg.group == "suwayomi") {
      suwayomi = { };
    };

    users.users = mkIf (cfg.user == "suwayomi") {
      suwayomi = {
        group = cfg.group;
        # Need to set the user home because the package writes to ~/.local/Tachidesk
        home = cfg.dataDir;
        description = "Suwayomi Daemon user";
        isSystemUser = true;
      };
    };

    systemd.tmpfiles.settings."10-suwayomi-server" = {
      "${cfg.dataDir}/.local/share/Tachidesk".d = {
        mode = "0700";
        inherit (cfg) user group;
      };
    };

    systemd.services.suwayomi-server =
      let
        configFile = format.generate "server.conf" (
          lib.pipe cfg.settings [
            (
              settings:
              lib.recursiveUpdate settings {
                server.basicAuthPasswordFile = null;
                server.basicAuthPassword =
                  if settings.server.basicAuthEnabled then "$TACHIDESK_SERVER_BASIC_AUTH_PASSWORD" else null;
              }
            )
            (lib.filterAttrsRecursive (_: x: x != null))
          ]
        );
      in
      {
        description = "A free and open source manga reader server that runs extensions built for Tachiyomi.";

        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];

        script = ''
          ${lib.optionalString cfg.settings.server.basicAuthEnabled ''
            export TACHIDESK_SERVER_BASIC_AUTH_PASSWORD="$(<${cfg.settings.server.basicAuthPasswordFile})"
          ''}
          ${lib.getExe pkgs.envsubst} -i ${configFile} -o ${cfg.dataDir}/.local/share/Tachidesk/server.conf
          ${lib.getExe cfg.package} -Dsuwayomi.tachidesk.config.server.rootDir=${cfg.dataDir}
        '';

        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;

          Type = "simple";
          Restart = "on-failure";

          StateDirectory = mkIf (cfg.dataDir == "/var/lib/suwayomi-server") "suwayomi-server";
        };
      };
  };

  meta = {
    maintainers = with lib.maintainers; [ ratcornu ];
    doc = ./suwayomi-server.md;
  };
}
