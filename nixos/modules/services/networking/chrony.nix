{ config, lib, pkgs, ... }:

with lib;

let

  stateDir = "/var/lib/chrony";

  keyFile = "/etc/chrony.keys";

  cfg = config.services.chrony;

  configFile = pkgs.writeText "chrony.conf" ''
    ${concatMapStringsSep "\n" (server: "server " + server) cfg.servers}

    ${optionalString
      cfg.initstepslew.enabled
      "initstepslew ${toString cfg.initstepslew.threshold} ${concatStringsSep " " cfg.initstepslew.servers}"
    }

    driftfile ${stateDir}/chrony.drift

    keyfile ${keyFile}

    ${optionalString (!config.time.hardwareClockInLocalTime) "rtconutc"}

    ${cfg.extraConfig}
  '';

  chronyFlags = "-n -m -u chrony -f ${configFile} ${toString cfg.extraFlags}";

in

{

  ###### interface

  options = {

    services.chrony = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to synchronise your machine's time using chrony.
          Make sure you disable NTP if you enable this service.
        '';
      };

      servers = mkOption {
        default = config.networking.timeServers;
        description = ''
          The set of NTP servers from which to synchronise.
        '';
      };

      initstepslew = mkOption {
        default = {
          enabled = true;
          threshold = 1000; # by default, same threshold as 'ntpd -g' (1000s)
          servers = cfg.servers;
        };
        description = ''
          Allow chronyd to make a rapid measurement of the system clock error at
          boot time, and to correct the system clock by stepping before normal
          operation begins.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration directives that should be added to
          <literal>chrony.conf</literal>
        '';
      };

      extraFlags = mkOption {
        default = [];
        example = [ "-s" ];
        type = types.listOf types.str;
        description = "Extra flags passed to the chronyd command.";
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    # Make chronyc available in the system path
    environment.systemPackages = [ pkgs.chrony ];

    users.groups = singleton
      { name = "chrony";
        gid = config.ids.gids.chrony;
      };

    users.users = singleton
      { name = "chrony";
        uid = config.ids.uids.chrony;
        group = "chrony";
        description = "chrony daemon user";
        home = stateDir;
      };

    services.timesyncd.enable = mkForce false;

    systemd.services.chronyd =
      { description = "chrony NTP daemon";

        wantedBy = [ "multi-user.target" ];
        wants = [ "time-sync.target" ];
        before = [ "time-sync.target" ];
        after = [ "network.target" ];
        conflicts = [ "ntpd.service" "systemd-timesyncd.service" ];

        path = [ pkgs.chrony ];

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir}
            touch ${keyFile}
            chmod 0640 ${keyFile}
            chown chrony:chrony ${stateDir} ${keyFile}
          '';

        serviceConfig =
          { ExecStart = "${pkgs.chrony}/bin/chronyd ${chronyFlags}";
          };
      };

  };

}
