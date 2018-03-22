{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.nexus;

in

{
  options = {
    services.nexus = {
      enable = mkEnableOption "Sonatype Nexus3 OSS service";

      user = mkOption {
        type = types.str;
        default = "nexus";
        description = "User which runs Nexus3.";
      };

      group = mkOption {
        type = types.str;
        default = "nexus";
        description = "Group which runs Nexus3.";
      };

      home = mkOption {
        type = types.str;
        default = "/var/lib/sonatype-work";
        description = "Home directory of the Nexus3 instance.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address to listen on.";
      };

      listenPort = mkOption {
        type = types.int;
        default = 8081;
        description = "Port to listen on.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers."${cfg.user}" = {
      isSystemUser = true;
      group = cfg.group;
    };

    users.extraGroups."${cfg.group}" = {};

    systemd.services.nexus = {
      description = "Sonatype Nexus3";

      wantedBy = [ "multi-user.target" ];

      path = [ cfg.home ];

      environment = {
        NEXUS_USER = cfg.user;
        NEXUS_HOME = cfg.home;
      };

      preStart = ''
        mkdir -p ${cfg.home}/nexus3/etc

        ln -sf ${cfg.home} /run/sonatype-work

        chown -R ${cfg.user}:${cfg.group} ${cfg.home}

        if [ ! -f ${cfg.home}/nexus3/etc/nexus.properties ]; then
          echo "# Jetty section" > ${cfg.home}/nexus3/etc/nexus.properties
          echo "application-port=${toString cfg.listenPort}" >> ${cfg.home}/nexus3/etc/nexus.properties
          echo "application-host=${toString cfg.listenAddress}" >> ${cfg.home}/nexus3/etc/nexus.properties
        else
          sed 's/^application-port=.*/application-port=${toString cfg.listenPort}/' -i ${cfg.home}/nexus3/etc/nexus.properties 
          sed 's/^# application-port=.*/application-port=${toString cfg.listenPort}/' -i ${cfg.home}/nexus3/etc/nexus.properties 
          sed 's/^application-host=.*/application-host=${toString cfg.listenAddress}/' -i ${cfg.home}/nexus3/etc/nexus.properties 
          sed 's/^# application-host=.*/application-host=${toString cfg.listenAddress}/' -i ${cfg.home}/nexus3/etc/nexus.properties 
        fi
      '';

      script = "${pkgs.nexus}/bin/nexus run";

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PrivateTmp = true;
        PermissionsStartOnly = true;
        LimitNOFILE = 102642;
      };
    };
  };

  meta.maintainers = with stdenv.lib.maintainers; [ ironpinguin ];
}
