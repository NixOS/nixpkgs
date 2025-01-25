{
  lib,
  pkgs,
  config,
  ...
}:
let
  settingsFormat = pkgs.formats.yaml { };

  # gemstash uses a yaml config where the keys are ruby symbols,
  # which means they start with ':'. This would be annoying to use
  # on the nix side, so we rewrite plain names instead.
  prefixColon =
    s:
    lib.listToAttrs (
      map (attrName: {
        name = ":${attrName}";
        value = if lib.isAttrs s.${attrName} then prefixColon s."${attrName}" else s."${attrName}";
      }) (lib.attrNames s)
    );

  # parse the port number out of the tcp://ip:port bind setting string
  parseBindPort = bind: lib.strings.toInt (lib.last (lib.strings.splitString ":" bind));

  cfg = config.services.gemstash;
in
{
  options.services.gemstash = {
    enable = lib.mkEnableOption "gemstash, a cache for rubygems.org and a private gem server";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for the port in {option}`services.gemstash.bind`.
      '';
    };

    settings = lib.mkOption {
      default = { };
      description = ''
        Configuration for Gemstash. The details can be found at in
        [gemstash documentation](https://github.com/rubygems/gemstash/blob/master/man/gemstash-configuration.5.md).
        Each key set here is automatically prefixed with ":" to match the gemstash expectations.
      '';
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          base_path = lib.mkOption {
            type = lib.types.path;
            default = "/var/lib/gemstash";
            description = "Path to store the gem files and the sqlite database. If left unchanged, the directory will be created.";
          };
          bind = lib.mkOption {
            type = lib.types.str;
            default = "tcp://0.0.0.0:9292";
            description = "Host and port combination for the server to listen on.";
          };
          db_adapter = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.enum [
                "sqlite3"
                "postgres"
                "mysql"
                "mysql2"
              ]
            );
            default = null;
            description = "Which database type to use. For choices other than sqlite3, the dbUrl has to be specified as well.";
          };
          db_url = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "The database to connect to when using postgres, mysql, or mysql2.";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      users.gemstash = {
        group = "gemstash";
        isSystemUser = true;
      };
      groups.gemstash = { };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      (parseBindPort cfg.settings.bind)
    ];

    systemd.services.gemstash = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = lib.mkMerge [
        {
          ExecStart = "${pkgs.gemstash}/bin/gemstash start --no-daemonize --config-file ${settingsFormat.generate "gemstash.yaml" (prefixColon cfg.settings)}";
          NoNewPrivileges = true;
          User = "gemstash";
          Group = "gemstash";
          PrivateTmp = true;
          RestrictSUIDSGID = true;
          LockPersonality = true;
        }
        (lib.mkIf (cfg.settings.base_path == "/var/lib/gemstash") {
          StateDirectory = "gemstash";
        })
      ];
    };
  };
}
