{ lib, pkgs, config, ... }:
with lib;

let
  settingsFormat = pkgs.formats.yaml { };

  # gemstash uses a yaml config where the keys are ruby symbols,
  # which means they start with ':'. This would be annoying to use
  # on the nix side, so we rewrite plain names instead.
  prefixColon = s: listToAttrs (map
    (attrName: {
      name = ":${attrName}";
      value =
        if isAttrs s.${attrName}
        then prefixColon s."${attrName}"
        else s."${attrName}";
    })
    (attrNames s));

  # parse the port number out of the tcp://ip:port bind setting string
  parseBindPort = bind: strings.toInt (last (strings.splitString ":" bind));

  cfg = config.services.gemstash;
in
{
  options.services.gemstash = {
    enable = mkEnableOption (lib.mdDoc "gemstash service");

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to open the firewall for the port in {option}`services.gemstash.bind`.
      '';
    };

    settings = mkOption {
      default = {};
      description = lib.mdDoc ''
        Configuration for Gemstash. The details can be found at in
        [gemstash documentation](https://github.com/rubygems/gemstash/blob/master/man/gemstash-configuration.5.md).
        Each key set here is automatically prefixed with ":" to match the gemstash expectations.
      '';
      type = types.submodule {
        freeformType = settingsFormat.type;
        options = {
          base_path = mkOption {
            type = types.path;
            default = "/var/lib/gemstash";
            description = lib.mdDoc "Path to store the gem files and the sqlite database. If left unchanged, the directory will be created.";
          };
          bind = mkOption {
            type = types.str;
            default = "tcp://0.0.0.0:9292";
            description = lib.mdDoc "Host and port combination for the server to listen on.";
          };
          db_adapter = mkOption {
            type = types.nullOr (types.enum [ "sqlite3" "postgres" "mysql" "mysql2" ]);
            default = null;
            description = lib.mdDoc "Which database type to use. For choices other than sqlite3, the dbUrl has to be specified as well.";
          };
          db_url = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = lib.mdDoc "The database to connect to when using postgres, mysql, or mysql2.";
          };
        };
      };
    };
  };

  config =
    mkIf cfg.enable {
      users = {
        users.gemstash = {
          group = "gemstash";
          isSystemUser = true;
        };
        groups.gemstash = { };
      };

      networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ (parseBindPort cfg.settings.bind) ];

      systemd.services.gemstash = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig = mkMerge [
          {
            ExecStart = "${pkgs.gemstash}/bin/gemstash start --no-daemonize --config-file ${settingsFormat.generate "gemstash.yaml" (prefixColon cfg.settings)}";
            NoNewPrivileges = true;
            User = "gemstash";
            Group = "gemstash";
            PrivateTmp = true;
            RestrictSUIDSGID = true;
            LockPersonality = true;
          }
          (mkIf (cfg.settings.base_path == "/var/lib/gemstash") {
            StateDirectory = "gemstash";
          })
        ];
      };
    };
}
