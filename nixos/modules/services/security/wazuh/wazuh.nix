{ config, lib, pkgs, ... }:

let
  wazuhUser = "wazuh";
  wazuhGroup = wazuhUser;
  stateDir = "/var/ossec";
  cfg = config.services.wazuh;
  pkg = config.services.wazuh.package;
  generatedConfig = import ./generate-agent-config.nix { cfg = config.services.wazuh; pkgs = pkgs; };
in
{
  options = {
    services.wazuh = {
      agent = {
        enable = lib.mkEnableOption "Wazuh agent";

        managerIP = lib.mkOption {
          type = lib.types.nonEmptyStr;
          description = ''
            The IP address or hostname of the manager.
          '';
          example = "192.168.1.2";
        };

        managerPort = lib.mkOption {
          type = lib.types.port;
          description = ''
            The port the manager is listening on to receive agent traffic.
          '';
          example = 1514;
          default = 1514;
        };

        extraConfig = lib.mkOption {
          type = lib.types.lines;
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

      package = lib.mkOption {
        default = pkgs.wazuh;
        defaultText = lib.literalExpression "pkgs.wazuh";
        type = lib.types.package;
        description = ''
          The Wazuh package to use.
        '';
      };
    };
  };

  config = lib.mkIf (cfg.agent.enable) {
    environment.systemPackages = [ pkg ];

    users.users.${ wazuhUser } = {
      isSystemUser = true;
      group = wazuhGroup;
      description = "Wazuh daemon user";
      home = stateDir;
    };

    users.groups.${ wazuhGroup } = { };

    systemd.tmpfiles.rules = [
      "d ${stateDir} 0750 ${wazuhUser} ${wazuhGroup}"
    ];

    systemd.services.wazuh-agent = lib.mkIf cfg.agent.enable {
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
