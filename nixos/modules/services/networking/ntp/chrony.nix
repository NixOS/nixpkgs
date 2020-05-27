{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.chrony;

  stateDir = "/var/lib/chrony";
  keyFile = "${stateDir}/chrony.keys";

  configFile = pkgs.writeText "chrony.conf" ''
    ${concatMapStringsSep "\n" (server: "server " + server + " iburst") cfg.servers}

    ${optionalString
      (cfg.initstepslew.enabled && (cfg.servers != []))
      "initstepslew ${toString cfg.initstepslew.threshold} ${concatStringsSep " " cfg.servers}"
    }

    driftfile ${stateDir}/chrony.drift
    keyfile ${keyFile}

    ${optionalString (!config.time.hardwareClockInLocalTime) "rtconutc"}

    ${cfg.extraConfig}
  '';

  chronyFlags = "-n -m -u chrony -f ${configFile} ${toString cfg.extraFlags}";
in
{
  options = {
    services.chrony = {
      enable = mkOption {
        type = types.bool;
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

  config = mkIf cfg.enable {
    meta.maintainers = with lib.maintainers; [ thoughtpolice ];

    environment.systemPackages = [ pkgs.chrony ];

    users.groups.chrony.gid = config.ids.gids.chrony;

    users.users.chrony =
      { uid = config.ids.uids.chrony;
        group = "chrony";
        description = "chrony daemon user";
        home = stateDir;
      };

    services.timesyncd.enable = mkForce false;

    systemd.services.systemd-timedated.environment = { SYSTEMD_TIMEDATED_NTP_SERVICES = "chronyd.service"; };

    systemd.tmpfiles.rules = [
      "d ${stateDir} 0755 chrony chrony - -"
      "f ${keyFile} 0640 chrony chrony -"
    ];

    systemd.services.chronyd =
      { description = "chrony NTP daemon";

        wantedBy = [ "multi-user.target" ];
        wants    = [ "time-sync.target" ];
        before   = [ "time-sync.target" ];
        after    = [ "network.target" ];
        conflicts = [ "ntpd.service" "systemd-timesyncd.service" ];

        path = [ pkgs.chrony ];

        unitConfig.ConditionCapability = "CAP_SYS_TIME";
        serviceConfig =
          { Type = "simple";
            ExecStart = "${pkgs.chrony}/bin/chronyd ${chronyFlags}";

            ProtectHome = "yes";
            ProtectSystem = "full";
            PrivateTmp = "yes";
            StateDirectory = "chrony";
          };

      };
  };
}
