{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.etebase-server;

  pythonEnv = pkgs.python3.withPackages (ps: with ps;
    [ etebase-server daphne ]);

  dbConfig = {
    sqlite3 = ''
      engine = django.db.backends.sqlite3
      name = ${cfg.dataDir}/db.sqlite3
    '';
  };

  defaultConfigIni = toString (pkgs.writeText "etebase-server.ini" ''
    [global]
    debug = false
    secret_file = ${if cfg.secretFile != null then cfg.secretFile else ""}
    media_root = ${cfg.dataDir}/media

    [allowed_hosts]
    allowed_host1 = ${cfg.host}

    [database]
    ${dbConfig."${cfg.database.type}"}
  '');

  configIni = if cfg.customIni != null then cfg.customIni else defaultConfigIni;

  defaultUser = "etebase-server";
in
{
  options = {
    services.etebase-server = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Whether to enable the Etebase server.

          Once enabled you need to create an admin user using the
          shell command <literal>etebase-server createsuperuser</literal>.
          Then you can login and create accounts on your-etebase-server.com/admin
        '';
      };

      secretFile = mkOption {
        default = null;
        type = with types; nullOr str;
        description = ''
          The path to a file containing the secret
          used as django's SECRET_KEY.
        '';
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/etebase-server";
        description = "Directory to store the Etebase server data.";
      };

      port = mkOption {
        type = with types; nullOr port;
        default = 8001;
        description = "Port to listen on.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open ports in the firewall for the server.
        '';
      };

      host = mkOption {
        type = types.str;
        default = "0.0.0.0";
        example = "localhost";
        description = ''
          Host to listen on.
        '';
      };

      unixSocket = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "The path to the socket to bind to.";
        example = "/run/etebase-server/etebase-server.sock";
      };

      database = {
        type = mkOption {
          type = types.enum [ "sqlite3" ];
          default = "sqlite3";
          description = ''
            Database engine to use.
            Currently only sqlite3 is supported.
            Other options can be configured using <literal>extraConfig</literal>.
          '';
        };
      };

      customIni = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          Custom etebase-server.ini.

          See <literal>etebase-src/etebase-server.ini.example</literal> for available options.

          Setting this option overrides the default config which is generated from the options
          <literal>secretFile</literal>, <literal>host</literal> and <literal>database</literal>.
        '';
        example = literalExample ''
          [global]
          debug = false
          secret_file = /path/to/secret
          media_root = /path/to/media

          [allowed_hosts]
          allowed_host1 = example.com

          [database]
          engine = django.db.backends.sqlite3
          name = db.sqlite3
        '';
      };

      user = mkOption {
        type = types.str;
        default = defaultUser;
        description = "User under which Etebase server runs.";
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      (runCommand "etebase-server" {
        buildInputs = [ makeWrapper ];
      } ''
        makeWrapper ${pythonEnv}/bin/etebase-server \
          $out/bin/etebase-server \
          --run "cd ${cfg.dataDir}" \
          --prefix ETEBASE_EASY_CONFIG_PATH : "${configIni}"
      '')
    ];

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} ${config.users.users.${cfg.user}.group} - -"
    ];

    systemd.services.etebase-server = {
      description = "An Etebase (EteSync 2.0) server";
      after = [ "network.target" "systemd-tmpfiles-setup.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Restart = "always";
        WorkingDirectory = cfg.dataDir;
      };
      environment = {
        PYTHONPATH="${pythonEnv}/${pkgs.python3.sitePackages}";
        ETEBASE_EASY_CONFIG_PATH="${configIni}";
      };
      preStart = ''
        # Auto-migrate on first run or if the package has changed
        versionFile="${cfg.dataDir}/src-version"
        if [[ $(cat "$versionFile" 2>/dev/null) != ${pkgs.etebase-server} ]]; then
          ${pythonEnv}/bin/etebase-server migrate
          echo ${pkgs.etebase-server} > "$versionFile"
        fi
      '';
      script =
        let
          networking = if cfg.unixSocket != null
          then "-u ${cfg.unixSocket}"
          else "-b 0.0.0.0 -p ${toString cfg.port}";
        in ''
          cd "${pythonEnv}/lib/etebase-server";
          ${pythonEnv}/bin/daphne ${networking} \
            etebase_server.asgi:application
        '';
    };

    users = optionalAttrs (cfg.user == defaultUser) {
      users.${defaultUser} = {
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
