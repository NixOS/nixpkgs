{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.oxidized;

  yaml = pkgs.formats.yaml { };
  toYamlFile =
    fn: attrs:
    pkgs.runCommand fn
      {
        preferLocalBuild = true;
      }
      ''
        cp ${yaml.generate fn attrs} $out

        # unquote Ruby YAML tags into YAML scalars
        sed -i -E "s/'(!ruby\/[^']*)'/\1/g" "$out"
      '';
in
{
  options.services.oxidized = {
    enable = lib.mkEnableOption "the oxidized configuration backup service";

    package = lib.mkPackageOption pkgs "oxidized" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "oxidized";
      description = ''
        User under which the oxidized service runs.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "oxidized";
      description = ''
        Group under which the oxidized service runs.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/oxidized";
      description = "State directory for the oxidized service.";
    };

    settings = lib.mkOption {
      type = lib.types.nullOr yaml.type;
      default = null;
      example = {
        debug = true;
        use_syslog = true;
        input = {
          default = "ssh";
          ssh.secure = true;
        };
        interval = 3600;
        retries = 3;
        model_map = {
          cisco = "ios";
          juniper = "junos";
          dell = "powerconnect";
          hp = "procurve";
        };
        source = {
          default = "csv";
          csv = {
            delimiter = "!ruby/regexp /:/";
            file = "/var/lib/oxidized/.config/oxidized/router.db";
            map = {
              name = 0;
              model = 1;
              username = 2;
              password = 3;
            };
          };
        };
        pid = "/var/lib/oxidized/.config/oxidized/pid";
        extensions = {
          oxidized-web = {
            load = true;
            listen = "127.0.0.1";
            port = 8888;
            vhosts = [
              "localhost"
              "127.0.0.1"
              "oxidized.example.com"
            ];
          };
        };
      };
      description = ''
        [Oxidized configuration] as a Nix attribute set installed at
        {file}`/etc/oxidized/config`.

        The resulting configuration file resides in the {file}`/nix/store`. Pass
        secret values via {option}`services.oxidized.userConfigFile` instead.

        This option is mutually exclusive with {option}`services.oxidied.configFile`.

        ::: {.note}
        Ruby-specific YAML tags can be passed as a quoted string. The config
        renderer will unquote tags starting with `!ruby/` in both keys and values.
        :::

        [Oxidized configuration]: https://github.com/ytti/oxidized/blob/master/docs/Configuration.md
      '';
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to the system-wide oxidized configuration file.

        This file will be symlinked to {file}`/etc/oxidized/config`.

        This option is mutually exclusive with {option}`services.oxidized.settings`.
      '';
    };

    userConfigFile = lib.mkOption {
      type = lib.types.nullOr (lib.types.pathWith { inStore = false; });
      default = null;
      example = "/run/keys/oxidized";
      description = ''
        Path to the per-user oxidized configuration file.

        This file will be symlinked to {file}`/var/lib/oxidized/.config/oxidized/config`.

        This config file is merged on top of the system-wide configuration file.
        which makes it suitable for passing secrets.
      '';
    };

    routerDB = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression ''
        pkgs.writeText "oxidized-router.db" '''
          hostname-sw1:powerconnect:username1:password2
          hostname-sw2:procurve:username2:password2
          # ... additional hosts
        '''
      '';
      description = ''
        Path to the file/database which contains the targets for oxidized.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.settings != null) != (cfg.configFile != null);
        message = "Oxidized must be configured via exactly one of `settings` or `configFile`.";
      }
    ];

    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      description = "Oxidized service user";
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
    };

    environment.etc."oxidized/config".source =
      if cfg.settings != null then toYamlFile "oxidized.yaml" cfg.settings else cfg.configFile;

    systemd.tmpfiles.settings."10-oxidized" = {
      "${cfg.dataDir}" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };

      "${cfg.dataDir}/.config" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };

      "${cfg.dataDir}/.config/oxidized" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };

    }
    // lib.optionalAttrs (cfg.userConfigFile != null) {
      "${cfg.dataDir}/.config/oxidized/config" = {
        "L+" = {
          argument = "${cfg.userConfigFile}";
          user = cfg.user;
          group = cfg.group;
        };
      };

    }
    // lib.optionalAttrs (cfg.routerDB != null) {
      "${cfg.dataDir}/.config/oxidized/router.db" = {
        "L+" = {
          argument = "${cfg.routerDB}";
          user = cfg.user;
          group = cfg.group;
        };
      };
    };

    systemd.services.oxidized = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        User = cfg.user;
        Group = cfg.group;
        UMask = "0077";
        NoNewPrivileges = true;
        Restart = "always";
        WorkingDirectory = cfg.dataDir;
        KillSignal = "SIGKILL";
        PIDFile = "${cfg.dataDir}/.config/oxidized/pid";
      };
    };
  };
}
