{ config, lib, options, pkgs, ... }:

let
  cfg = config.services.epgstation;
  opt = options.services.epgstation;

  description = "EPGStation: DVR system for Mirakurun-managed TV tuners";

  username = config.users.users.epgstation.name;
  groupname = config.users.users.epgstation.group;
  mirakurun = {
    sock = config.services.mirakurun.unixSocket;
    option = options.services.mirakurun.unixSocket;
  };

  yaml = pkgs.formats.yaml { };
  settingsTemplate = yaml.generate "config.yml" cfg.settings;
  preStartScript = pkgs.writeScript "epgstation-prestart" ''
    #!${pkgs.runtimeShell}

    DB_PASSWORD_FILE=${lib.escapeShellArg cfg.database.passwordFile}

    if [[ ! -f "$DB_PASSWORD_FILE" ]]; then
      printf "[FATAL] File containing the DB password was not found in '%s'. Double check the NixOS option '%s'." \
        "$DB_PASSWORD_FILE" ${lib.escapeShellArg opt.database.passwordFile} >&2
      exit 1
    fi

    DB_PASSWORD="$(head -n1 ${lib.escapeShellArg cfg.database.passwordFile})"

    # setup configuration
    touch /etc/epgstation/config.yml
    chmod 640 /etc/epgstation/config.yml
    sed \
      -e "s,@dbPassword@,$DB_PASSWORD,g" \
      ${settingsTemplate} > /etc/epgstation/config.yml
    chown "${username}:${groupname}" /etc/epgstation/config.yml

    # NOTE: Use password authentication, since mysqljs does not yet support auth_socket
    if [ ! -e /var/lib/epgstation/db-created ]; then
      ${pkgs.mariadb}/bin/mysql -e \
        "GRANT ALL ON \`${cfg.database.name}\`.* TO '${username}'@'localhost' IDENTIFIED by '$DB_PASSWORD';"
      touch /var/lib/epgstation/db-created
    fi
  '';

  streamingConfig = lib.importJSON ./streaming.json;
  logConfig = yaml.generate "logConfig.yml" {
    appenders.stdout.type = "stdout";
    categories = {
      default = { appenders = [ "stdout" ]; level = "info"; };
      system = { appenders = [ "stdout" ]; level = "info"; };
      access = { appenders = [ "stdout" ]; level = "info"; };
      stream = { appenders = [ "stdout" ]; level = "info"; };
    };
  };

  # Deprecate top level options that are redundant.
  deprecateTopLevelOption = config:
    lib.mkRenamedOptionModule
      ([ "services" "epgstation" ] ++ config)
      ([ "services" "epgstation" "settings" ] ++ config);

  removeOption = config: instruction:
    lib.mkRemovedOptionModule
      ([ "services" "epgstation" ] ++ config)
      instruction;
in
{
  meta.maintainers = with lib.maintainers; [ midchildan ];

  imports = [
    (deprecateTopLevelOption [ "port" ])
    (deprecateTopLevelOption [ "socketioPort" ])
    (deprecateTopLevelOption [ "clientSocketioPort" ])
    (removeOption [ "basicAuth" ]
      "Use a TLS-terminated reverse proxy with authentication instead.")
  ];

  options.services.epgstation = {
    enable = lib.mkEnableOption description;

    package = lib.mkOption {
      default = pkgs.epgstation;
      type = lib.types.package;
      defaultText = lib.literalExpression "pkgs.epgstation";
      description = "epgstation package to use";
    };

    usePreconfiguredStreaming = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Use preconfigured default streaming options.

        Upstream defaults:
        <link xlink:href="https://github.com/l3tnun/EPGStation/blob/master/config/config.yml.template"/>
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
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

    database = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "epgstation";
        description = ''
          Name of the MySQL database that holds EPGStation's data.
        '';
      };

      passwordFile = lib.mkOption {
        type = lib.types.path;
        example = "/run/keys/epgstation-db-password";
        description = ''
          A file containing the password for the database named
          <option>database.name</option>.
        '';
      };
    };

    # The defaults for some options come from the upstream template
    # configuration, which is the one that users would get if they follow the
    # upstream instructions. This is, in some cases, different from the
    # application defaults. Some options like encodeProcessNum and
    # concurrentEncodeNum doesn't have an optimal default value that works for
    # all hardware setups and/or performance requirements. For those kind of
    # options, the application default wouldn't always result in the expected
    # out-of-the-box behavior because it's the responsibility of the user to
    # configure them according to their needs. In these cases, the value in the
    # upstream template configuration should serve as a "good enough" default.
    settings = lib.mkOption {
      description = ''
        Options to add to config.yml.

        Documentation:
        <link xlink:href="https://github.com/l3tnun/EPGStation/blob/master/doc/conf-manual.md"/>
      '';

      default = { };
      example = {
        recPriority = 20;
        conflictPriority = 10;
      };

      type = lib.types.submodule {
        freeformType = yaml.type;

        options.port = lib.mkOption {
          type = lib.types.port;
          default = 20772;
          description = ''
            HTTP port for EPGStation to listen on.
          '';
        };

        options.socketioPort = lib.mkOption {
          type = lib.types.port;
          default = cfg.settings.port + 1;
          defaultText = lib.literalExpression "config.${opt.settings}.port + 1";
          description = ''
            Socket.io port for EPGStation to listen on. It is valid to share
            ports with <option>${opt.settings}.port</option>.
          '';
        };

        options.clientSocketioPort = lib.mkOption {
          type = lib.types.port;
          default = cfg.settings.socketioPort;
          defaultText = lib.literalExpression "config.${opt.settings}.socketioPort";
          description = ''
            Socket.io port that the web client is going to connect to. This may
            be different from <option>${opt.settings}.socketioPort</option> if
            EPGStation is hidden behind a reverse proxy.
          '';
        };

        options.mirakurunPath = with mirakurun; lib.mkOption {
          type = lib.types.str;
          default = "http+unix://${lib.replaceStrings ["/"] ["%2F"] sock}";
          defaultText = lib.literalExpression ''
            "http+unix://''${lib.replaceStrings ["/"] ["%2F"] config.${option}}"
          '';
          example = "http://localhost:40772";
          description = "URL to connect to Mirakurun.";
        };

        options.encodeProcessNum = lib.mkOption {
          type = lib.types.ints.positive;
          default = 4;
          description = ''
            The maximum number of processes that EPGStation would allow to run
            at the same time for encoding or streaming videos.
          '';
        };

        options.concurrentEncodeNum = lib.mkOption {
          type = lib.types.ints.positive;
          default = 1;
          description = ''
            The maximum number of encoding jobs that EPGStation would run at the
            same time.
          '';
        };

        options.encode = lib.mkOption {
          type = with lib.types; listOf attrs;
          description = "Encoding presets for recorded videos.";
          default = [
            {
              name = "H.264";
              cmd = "%NODE% ${cfg.package}/libexec/enc.js";
              suffix = ".mp4";
            }
          ];
          defaultText = lib.literalExpression ''
            [
              {
                name = "H.264";
                cmd = "%NODE% config.${opt.package}/libexec/enc.js";
                suffix = ".mp4";
              }
            ]
          '';
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(lib.hasAttr "readOnlyOnce" cfg.settings);
        message = ''
          The option config.${opt.settings}.readOnlyOnce can no longer be used
          since it's been removed. No replacements are available.
        '';
      }
    ];

    environment.etc = {
      "epgstation/epgUpdaterLogConfig.yml".source = logConfig;
      "epgstation/operatorLogConfig.yml".source = logConfig;
      "epgstation/serviceLogConfig.yml".source = logConfig;
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = with cfg.settings; [ port socketioPort ];
    };

    users.users.epgstation = {
      description = "EPGStation user";
      group = config.users.groups.epgstation.name;
      isSystemUser = true;
    };

    users.groups.epgstation = { };

    services.mirakurun.enable = lib.mkDefault true;

    services.mysql = {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      # FIXME: enable once mysqljs supports auth_socket
      # ensureUsers = [ {
      #   name = username;
      #   ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
      # } ];
    };

    services.epgstation.settings =
      let
        defaultSettings = {
          dbtype = lib.mkDefault "mysql";
          mysql = {
            socketPath = lib.mkDefault "/run/mysqld/mysqld.sock";
            user = username;
            password = lib.mkDefault "@dbPassword@";
            database = cfg.database.name;
          };

          ffmpeg = lib.mkDefault "${pkgs.ffmpeg-full}/bin/ffmpeg";
          ffprobe = lib.mkDefault "${pkgs.ffmpeg-full}/bin/ffprobe";

          # for disambiguation with TypeScript files
          recordedFileExtension = lib.mkDefault ".m2ts";
        };
      in
      lib.mkMerge [
        defaultSettings
        (lib.mkIf cfg.usePreconfiguredStreaming streamingConfig)
      ];

    systemd.tmpfiles.rules = [
      "d '/var/lib/epgstation/streamfiles' - ${username} ${groupname} - -"
      "d '/var/lib/epgstation/recorded' - ${username} ${groupname} - -"
      "d '/var/lib/epgstation/thumbnail' - ${username} ${groupname} - -"
    ];

    systemd.services.epgstation = {
      inherit description;

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ]
        ++ lib.optional config.services.mirakurun.enable "mirakurun.service"
        ++ lib.optional config.services.mysql.enable "mysql.service";

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/epgstation start";
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
