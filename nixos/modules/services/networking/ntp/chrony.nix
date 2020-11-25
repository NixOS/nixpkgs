{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.chrony;

  runDir = "/var/run/chrony";
  stateDir = "/var/lib/chrony";
  driftFile = "${stateDir}/chrony.drift";
  keyFile = "${stateDir}/chrony.keys";

  configFile = pkgs.writeText "chrony.conf" ''
    ${concatMapStringsSep "\n" (server: "server " + server + " iburst") cfg.servers}

    ${optionalString
      (cfg.initstepslew.enabled && (cfg.servers != []))
      "initstepslew ${toString cfg.initstepslew.threshold} ${concatStringsSep " " cfg.servers}"
    }

    driftfile ${driftFile}
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
      "f ${driftFile} 0640 chrony chrony -"
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

            KeyringMode = "private";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            NoNewPrivileges = true;
            PrivateMounts = "yes";
            PrivateTmp = "yes";
            ProtectControlGroups = true;
            ProtectHome = "yes";
            ProtectHostname = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectSystem = "strict";
            ReadWritePaths = [ runDir stateDir ];
            RemoveIPC = true;
            RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallFilter = "@system-service @clock";
            SystemCallArchitectures = "native";

            # even though in the default configuration chrony does not access the rtc clock,
            # it may be configured to so so either with the 'rtcfile' configuration option
            # or using the '-s' flag. so we make sure rtc devices can still be used by it.
            # at the same time there is no need for chrony to access any other device types.
            DeviceAllow = "char-rtc";
            DevicePolicy = "closed";

          };

      };
  };
}
