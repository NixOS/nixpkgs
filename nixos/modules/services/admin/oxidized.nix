{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.oxidized;
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

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      example = lib.literalExpression ''
        pkgs.writeText "oxidized-config.yml" '''
          ---
          debug: true
          use_syslog: true
          input:
            default: ssh
            ssh:
              secure: true
          interval: 3600
          model_map:
            dell: powerconnect
            hp: procurve
          source:
            default: csv
            csv:
              delimiter: !ruby/regexp /:/
              file: "/var/lib/oxidized/.config/oxidized/router.db"
              map:
                name: 0
                model: 1
                username: 2
                password: 3
          pid: "/var/lib/oxidized/.config/oxidized/pid"
          rest: 127.0.0.1:8888
          retries: 3
          # ... additional config
        ''';
      '';
      description = ''
        Path to the oxidized configuration file.
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
    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      description = "Oxidized service user";
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
    };

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
    // lib.optionalAttrs (cfg.configFile != null) {
      "${cfg.dataDir}/.config/oxidized/config" = {
        "L+" = {
          argument = "${cfg.configFile}";
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
