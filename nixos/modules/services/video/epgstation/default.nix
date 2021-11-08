{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.epgstation;

  username = config.users.users.epgstation.name;
  groupname = config.users.users.epgstation.group;

  settingsFmt = pkgs.formats.json {};
  settingsTemplate = settingsFmt.generate "config.json" cfg.settings;
  preStartScript = pkgs.writeScript "epgstation-prestart" ''
    #!${pkgs.runtimeShell}

    PASSWORD="$(head -n1 "${cfg.basicAuth.passwordFile}")"
    DB_PASSWORD="$(head -n1 "${cfg.database.passwordFile}")"

    # setup configuration
    touch /etc/epgstation/config.json
    chmod 640 /etc/epgstation/config.json
    sed \
      -e "s,@password@,$PASSWORD,g" \
      -e "s,@dbPassword@,$DB_PASSWORD,g" \
      ${settingsTemplate} > /etc/epgstation/config.json
    chown "${username}:${groupname}" /etc/epgstation/config.json

    # NOTE: Use password authentication, since mysqljs does not yet support auth_socket
    if [ ! -e /var/lib/epgstation/db-created ]; then
      ${pkgs.mariadb}/bin/mysql -e \
        "GRANT ALL ON \`${cfg.database.name}\`.* TO '${username}'@'localhost' IDENTIFIED by '$DB_PASSWORD';"
      touch /var/lib/epgstation/db-created
    fi
  '';

  streamingConfig = lib.importJSON ./streaming.json;
  logConfig = {
    appenders.stdout.type = "stdout";
    categories = {
      default = { appenders = [ "stdout" ]; level = "info"; };
      system = { appenders = [ "stdout" ]; level = "info"; };
      access = { appenders = [ "stdout" ]; level = "info"; };
      stream = { appenders = [ "stdout" ]; level = "info"; };
    };
  };

  defaultPassword = "INSECURE_GO_CHECK_CONFIGURATION_NIX\n";
in
{
  options.services.epgstation = {
    enable = mkEnableOption pkgs.epgstation.meta.description;

    usePreconfiguredStreaming = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Use preconfigured default streaming options.

        Upstream defaults:
        <link xlink:href="https://github.com/l3tnun/EPGStation/blob/master/config/config.sample.json"/>
      '';
    };

    port = mkOption {
      type = types.port;
      default = 20772;
      description = ''
        HTTP port for EPGStation to listen on.
      '';
    };

    socketioPort = mkOption {
      type = types.port;
      default = cfg.port + 1;
      description = ''
        Socket.io port for EPGStation to listen on.
      '';
    };

    clientSocketioPort = mkOption {
      type = types.port;
      default = cfg.socketioPort;
      description = ''
        Socket.io port that the web client is going to connect to. This may be
        different from <option>socketioPort</option> if EPGStation is hidden
        behind a reverse proxy.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open ports in the firewall for the EPGStation web interface.

        <warning>
          <para>
            Exposing EPGStation to the open internet is generally advised
            against. Only use it inside a trusted local network, or consider
            putting it behind a VPN if you want remote access.
          </para>
        </warning>
      '';
    };

    basicAuth = {
      user = mkOption {
        type = with types; nullOr str;
        default = null;
        example = "epgstation";
        description = ''
          Basic auth username for EPGStation. If <literal>null</literal>, basic
          auth will be disabled.

          <warning>
            <para>
              Basic authentication has known weaknesses, the most critical being
              that it sends passwords over the network in clear text. Use this
              feature to control access to EPGStation within your family and
              friends, but don't rely on it for security.
            </para>
          </warning>
        '';
      };

      passwordFile = mkOption {
        type = types.path;
        default = pkgs.writeText "epgstation-password" defaultPassword;
        defaultText = literalDocBook ''a file containing <literal>${defaultPassword}</literal>'';
        example = "/run/keys/epgstation-password";
        description = ''
          A file containing the password for <option>basicAuth.user</option>.
        '';
      };
    };

    database =  {
      name = mkOption {
        type = types.str;
        default = "epgstation";
        description = ''
          Name of the MySQL database that holds EPGStation's data.
        '';
      };

      passwordFile = mkOption {
        type = types.path;
        default = pkgs.writeText "epgstation-db-password" defaultPassword;
        defaultText = literalDocBook ''a file containing <literal>${defaultPassword}</literal>'';
        example = "/run/keys/epgstation-db-password";
        description = ''
          A file containing the password for the database named
          <option>database.name</option>.
        '';
      };
    };

    settings = mkOption {
      description = ''
        Options to add to config.json.

        Documentation:
        <link xlink:href="https://github.com/l3tnun/EPGStation/blob/master/doc/conf-manual.md"/>
      '';

      default = {};
      example = {
        recPriority = 20;
        conflictPriority = 10;
      };

      type = types.submodule {
        freeformType = settingsFmt.type;

        options.readOnlyOnce = mkOption {
          type = types.bool;
          default = false;
          description = "Don't reload configuration files at runtime.";
        };

        options.mirakurunPath = mkOption (let
          sockPath = config.services.mirakurun.unixSocket;
        in {
          type = types.str;
          default = "http+unix://${replaceStrings ["/"] ["%2F"] sockPath}";
          example = "http://localhost:40772";
          description = "URL to connect to Mirakurun.";
        });

        options.encode = mkOption {
          type = with types; listOf attrs;
          description = "Encoding presets for recorded videos.";
          default = [
            {
              name = "H264";
              cmd = "${pkgs.epgstation}/libexec/enc.sh main";
              suffix = ".mp4";
              default = true;
            }
            {
              name = "H264-sub";
              cmd = "${pkgs.epgstation}/libexec/enc.sh sub";
              suffix = "-sub.mp4";
            }
          ];
          defaultText = literalExpression ''
            [
              {
                name = "H264";
                cmd = "''${pkgs.epgstation}/libexec/enc.sh main";
                suffix = ".mp4";
                default = true;
              }
              {
                name = "H264-sub";
                cmd = "''${pkgs.epgstation}/libexec/enc.sh sub";
                suffix = "-sub.mp4";
              }
            ]
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.etc = {
      "epgstation/operatorLogConfig.json".text = builtins.toJSON logConfig;
      "epgstation/serviceLogConfig.json".text = builtins.toJSON logConfig;
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = with cfg; [ port socketioPort ];
    };

    users.users.epgstation = {
      description = "EPGStation user";
      group = config.users.groups.epgstation.name;
      isSystemUser = true;
    };

    users.groups.epgstation = {};

    services.mirakurun.enable = mkDefault true;

    services.mysql = {
      enable = mkDefault true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      # FIXME: enable once mysqljs supports auth_socket
      # ensureUsers = [ {
      #   name = username;
      #   ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
      # } ];
    };

    services.epgstation.settings = let
      defaultSettings = {
        serverPort = cfg.port;
        socketioPort = cfg.socketioPort;
        clientSocketioPort = cfg.clientSocketioPort;

        dbType = mkDefault "mysql";
        mysql = {
          user = username;
          database = cfg.database.name;
          socketPath = mkDefault "/run/mysqld/mysqld.sock";
          password = mkDefault "@dbPassword@";
          connectTimeout = mkDefault 1000;
          connectionLimit = mkDefault 10;
        };

        basicAuth = mkIf (cfg.basicAuth.user != null) {
          user = mkDefault cfg.basicAuth.user;
          password = mkDefault "@password@";
        };

        ffmpeg = mkDefault "${pkgs.ffmpeg-full}/bin/ffmpeg";
        ffprobe = mkDefault "${pkgs.ffmpeg-full}/bin/ffprobe";

        fileExtension = mkDefault ".m2ts";
        maxEncode = mkDefault 2;
        maxStreaming = mkDefault 2;
      };
    in
    mkMerge [
      defaultSettings
      (mkIf cfg.usePreconfiguredStreaming streamingConfig)
    ];

    systemd.tmpfiles.rules = [
      "d '/var/lib/epgstation/streamfiles' - ${username} ${groupname} - -"
      "d '/var/lib/epgstation/recorded' - ${username} ${groupname} - -"
      "d '/var/lib/epgstation/thumbnail' - ${username} ${groupname} - -"
    ];

    systemd.services.epgstation = {
      description = pkgs.epgstation.meta.description;
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
      ] ++ optional config.services.mirakurun.enable "mirakurun.service"
        ++ optional config.services.mysql.enable "mysql.service";

      serviceConfig = {
        ExecStart = "${pkgs.epgstation}/bin/epgstation start";
        ExecStartPre = "+${preStartScript}";
        User = username;
        Group = groupname;
        StateDirectory = "epgstation";
        LogsDirectory = "epgstation";
        ConfigurationDirectory = "epgstation";
      };
    };
  };
}
