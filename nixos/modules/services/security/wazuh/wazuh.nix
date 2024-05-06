{ config, lib, pkgs, ... }:

with lib;
let
  wazuhUser = "wazuh";
  wazuhGroup = wazuhUser;
  stateDir = "/var/ossec";
  cfg = config.services.wazuh;
  pkg = config.services.wazuh.package;
  generatedConfig = import ./generate-agent-config.nix { cfg = config.services.wazuh; pkgs = pkgs; };
  rsyncPath = "${pkgs.rsync}/bin";
in {
  options = {
    services.wazuh = {
      agent = {
        enable = mkEnableOption "Wazuh agent";

        managerIP = mkOption {
          type = types.str;
          description = ''
            The IP address or hostname of the manager. This is a required value.
          '';
          example = "192.168.1.2";
        };

        managerPort = mkOption {
          type = types.int;
          description = ''
            The port the manager is listening on to receive agent traffic.
          '';
          example = 1514;
          default = 1514;
        };

        extraConfig = mkOption {
          type = types.lines;
          description = ''
            Extra configuration values to be appended to the bottom of ossec.conf.
          '';
          default = "";
          example = ''
          <!-- The added ossec_config root tag is required -->
          <ossec_config>
            <!-- Extra configuration options as needed -->
          </ossec_config>
          '';
        };
      };

      package = mkOption {
        default = pkgs.wazuh;
        defaultText = literalExpression "pkgs.wazuh";
        type = types.package;
        description = ''
        The Wazuh package to use.
        '';
      };
    };
  };

  config = mkIf ( cfg.agent.enable ) {
    environment.systemPackages = [ pkg ];

    assertions = [
      {
        assertion = !( cfg.agent.managerIP == "" );
        message = "services.wazuh.agent.managerIP must be set";
      }
      {
        assertion = cfg.agent.managerPort > 0 && cfg.agent.managerPort <= 65535;
        message = "services.wazuh.agent.managerPort is set to a port out of range";
      }
    ];

    users.users.${ wazuhUser } = {
      uid = config.ids.uids.wazuh;
      group = wazuhGroup;
      description = "Wazuh daemon user";
      home = stateDir;
    };

    users.groups.${ wazuhGroup } = {
      gid = config.ids.gids.wazuh;
    };

    systemd.tmpfiles.rules = [
      "d ${stateDir} 0750 ${wazuhUser} ${wazuhGroup}"
    ];

    systemd.services.wazuh-agent = mkIf cfg.agent.enable {
      path = [
        "/run/current-system/sw"
      ];
      description = "Wazuh agent";
      wants = [ "network-online.target" ];
      after = [ "network.target" "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        rsync -av --exclude '/etc/client.keys' --exclude '/logs/' ${pkg}/ ${stateDir}/
        cp ${generatedConfig} ${stateDir}/etc/ossec.conf

        find ${stateDir} -type f -exec chmod 644 {} \;
        find ${stateDir} -type d -exec chmod 750 {} \;
        chmod u+x ${stateDir}/bin/*
        chmod u+x ${stateDir}/active-response/bin/*
        chown -R ${wazuhUser}:${wazuhGroup} ${stateDir}
      '';

      serviceConfig = {
        Type = "forking";
        WorkingDirectory = stateDir;
        ExecStart = "${stateDir}/bin/wazuh-control start";
        ExecStop = "${stateDir}/bin/wazuh-control stop";
        ExecReload = "${stateDir}/bin/wazuh-control reload";
        KillMode = "process";
        RemainAfterExit = "yes";
      };
    };
  };
}
