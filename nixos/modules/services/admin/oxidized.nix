{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.oxidized;
in
{
  options.services.oxidized = {
    enable = mkEnableOption "the oxidized configuration backup service";

    user = mkOption {
      type = types.str;
      default = "oxidized";
      description = ''
        User under which the oxidized service runs.
      '';
    };

    group = mkOption {
      type = types.str;
      default = "oxidized";
      description = ''
        Group under which the oxidized service runs.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/oxidized";
      description = "State directory for the oxidized service.";
    };

    configFile = mkOption {
      type = types.path;
      example = literalExpression ''
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

    routerDB = mkOption {
      type = types.path;
      example = literalExpression ''
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

  config = mkIf cfg.enable {
    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      description = "Oxidized service user";
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
    };

    systemd.services.oxidized = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        mkdir -p ${cfg.dataDir}/.config/oxidized
        ln -f -s ${cfg.routerDB} ${cfg.dataDir}/.config/oxidized/router.db
        ln -f -s ${cfg.configFile} ${cfg.dataDir}/.config/oxidized/config
      '';

      serviceConfig = {
        ExecStart = "${pkgs.oxidized}/bin/oxidized";
        User = cfg.user;
        Group = cfg.group;
        UMask = "0077";
        NoNewPrivileges = true;
        Restart  = "always";
        WorkingDirectory = cfg.dataDir;
        KillSignal = "SIGKILL";
        PIDFile = "${cfg.dataDir}/.config/oxidized/pid";
      };
    };
  };
}
