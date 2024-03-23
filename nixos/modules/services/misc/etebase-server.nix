{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.etebase-server;

  iniFmt = pkgs.formats.ini {};

  configIni = iniFmt.generate "etebase-server.ini" cfg.settings;

  defaultUser = "etebase-server";
in
{
  imports = [
    (mkRemovedOptionModule
      [ "services" "etebase-server" "customIni" ]
      "Set the option `services.etebase-server.settings' instead.")
    (mkRemovedOptionModule
      [ "services" "etebase-server" "database" ]
      "Set the option `services.etebase-server.settings.database' instead.")
    (mkRenamedOptionModule
      [ "services" "etebase-server" "secretFile" ]
      [ "services" "etebase-server" "settings" "secret_file" ])
    (mkRenamedOptionModule
      [ "services" "etebase-server" "host" ]
      [ "services" "etebase-server" "settings" "allowed_hosts" "allowed_host1" ])
  ];

  options = {
    services.etebase-server = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = lib.mdDoc ''
          Whether to enable the Etebase server.

          Once enabled you need to create an admin user by invoking the
          shell command `etebase-server createsuperuser` with
          the user specified by the `user` option or a superuser.
          Then you can login and create accounts on your-etebase-server.com/admin
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.python3.pkgs.etebase-server;
        defaultText = literalExpression "pkgs.python3.pkgs.etebase-server";
        description = lib.mdDoc "etebase-server package to use.";
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/etebase-server";
        description = lib.mdDoc "Directory to store the Etebase server data.";
      };

      port = mkOption {
        type = with types; nullOr port;
        default = 8001;
        description = lib.mdDoc "Port to listen on.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to open ports in the firewall for the server.
        '';
      };

      unixSocket = mkOption {
        type = with types; nullOr str;
        default = null;
        description = lib.mdDoc "The path to the socket to bind to.";
        example = "/run/etebase-server/etebase-server.sock";
      };

      settings = mkOption {
        type = lib.types.submodule {
          freeformType = iniFmt.type;

          options = {
            global = {
              debug = mkOption {
                type = types.bool;
                default = false;
                description = lib.mdDoc ''
                  Whether to set django's DEBUG flag.
                '';
              };
              secret_file = mkOption {
                type = with types; nullOr str;
                default = null;
                description = lib.mdDoc ''
                  The path to a file containing the secret
                  used as django's SECRET_KEY.
                '';
              };
              static_root = mkOption {
                type = types.str;
                default = "${cfg.dataDir}/static";
                defaultText = literalExpression ''"''${config.services.etebase-server.dataDir}/static"'';
                description = lib.mdDoc "The directory for static files.";
              };
              media_root = mkOption {
                type = types.str;
                default = "${cfg.dataDir}/media";
                defaultText = literalExpression ''"''${config.services.etebase-server.dataDir}/media"'';
                description = lib.mdDoc "The media directory.";
              };
            };
            allowed_hosts = {
              allowed_host1 = mkOption {
                type = types.str;
                default = "0.0.0.0";
                example = "localhost";
                description = lib.mdDoc ''
                  The main host that is allowed access.
                '';
              };
            };
            database = {
              engine = mkOption {
                type = types.enum [ "django.db.backends.sqlite3" "django.db.backends.postgresql" ];
                default = "django.db.backends.sqlite3";
                description = lib.mdDoc "The database engine to use.";
              };
              name = mkOption {
                type = types.str;
                default = "${cfg.dataDir}/db.sqlite3";
                defaultText = literalExpression ''"''${config.services.etebase-server.dataDir}/db.sqlite3"'';
                description = lib.mdDoc "The database name.";
              };
            };
          };
        };
        default = {};
        description = lib.mdDoc ''
          Configuration for `etebase-server`. Refer to
          <https://github.com/etesync/server/blob/master/etebase-server.ini.example>
          and <https://github.com/etesync/server/wiki>
          for details on supported values.
        '';
        example = {
          global = {
            debug = true;
            media_root = "/path/to/media";
          };
          allowed_hosts = {
            allowed_host2 = "localhost";
          };
        };
      };

      user = mkOption {
        type = types.str;
        default = defaultUser;
        description = lib.mdDoc "User under which Etebase server runs.";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      (runCommand "etebase-server" {
        nativeBuildInputs = [ makeWrapper ];
      } ''
        makeWrapper ${cfg.package}/bin/etebase-server \
          $out/bin/etebase-server \
          --chdir ${escapeShellArg cfg.dataDir} \
          --prefix ETEBASE_EASY_CONFIG_PATH : "${configIni}"
      '')
    ];

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} ${config.users.users.${cfg.user}.group} - -"
    ] ++ lib.optionals (cfg.unixSocket != null) [
      "d '${builtins.dirOf cfg.unixSocket}' - ${cfg.user} ${config.users.users.${cfg.user}.group} - -"
    ];

    systemd.services.etebase-server = {
      description = "An Etebase (EteSync 2.0) server";
      after = [ "network.target" "systemd-tmpfiles-setup.service" ];
      path = [ cfg.package ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Restart = "always";
        WorkingDirectory = cfg.dataDir;
      };
      environment = {
        ETEBASE_EASY_CONFIG_PATH = configIni;
        PYTHONPATH = cfg.package.pythonPath;
      };
      preStart = ''
        # Auto-migrate on first run or if the package has changed
        versionFile="${cfg.dataDir}/src-version"
        if [[ $(cat "$versionFile" 2>/dev/null) != ${cfg.package} ]]; then
          etebase-server migrate --no-input
          etebase-server collectstatic --no-input --clear
          echo ${cfg.package} > "$versionFile"
        fi
      '';
      script =
        let
          python = cfg.package.python;
          networking = if cfg.unixSocket != null
          then "--uds ${cfg.unixSocket}"
          else "--host 0.0.0.0 --port ${toString cfg.port}";
        in ''
          ${python.pkgs.uvicorn}/bin/uvicorn ${networking} \
            --app-dir ${cfg.package}/${cfg.package.python.sitePackages} \
            etebase_server.asgi:application
        '';
    };

    users = optionalAttrs (cfg.user == defaultUser) {
      users.${defaultUser} = {
        isSystemUser = true;
        group = defaultUser;
        home = cfg.dataDir;
      };

      groups.${defaultUser} = {};
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
