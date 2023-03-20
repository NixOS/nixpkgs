{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.chrony;
  chronyPkg = cfg.package;

  stateDir = cfg.directory;
  driftFile = "${stateDir}/chrony.drift";
  keyFile = "${stateDir}/chrony.keys";

  configFile = pkgs.writeText "chrony.conf" ''
    ${concatMapStringsSep "\n" (server: "server " + server + " " + cfg.serverOption + optionalString (cfg.enableNTS) " nts") cfg.servers}

    ${optionalString
      (cfg.initstepslew.enabled && (cfg.servers != []))
      "initstepslew ${toString cfg.initstepslew.threshold} ${concatStringsSep " " cfg.servers}"
    }

    driftfile ${driftFile}
    keyfile ${keyFile}
    ${optionalString (cfg.enableNTS) "ntsdumpdir ${stateDir}"}

    ${optionalString (!config.time.hardwareClockInLocalTime) "rtconutc"}

    ${cfg.extraConfig}
  '';

  chronyFlags = [ "-n" "-m" "-u" "chrony" "-f" "${configFile}" ] ++ cfg.extraFlags;
in
{
  options = {
    services.chrony = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to synchronise your machine's time using chrony.
          Make sure you disable NTP if you enable this service.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.chrony;
        defaultText = literalExpression "pkgs.chrony";
        description = lib.mdDoc ''
          Which chrony package to use.
        '';
      };

      servers = mkOption {
        default = config.networking.timeServers;
        defaultText = literalExpression "config.networking.timeServers";
        type = types.listOf types.str;
        description = lib.mdDoc ''
          The set of NTP servers from which to synchronise.
        '';
      };

      serverOption = mkOption {
        default = "iburst";
        type = types.enum [ "iburst" "offline" ];
        description = lib.mdDoc ''
          Set option for server directives.

          Use "iburst" to rapidly poll on startup. Recommended if your machine
          is consistently online.

          Use "offline" to prevent polling on startup. Recommended if your
          machine boots offline or is otherwise frequently offline.
        '';
      };

      enableNTS = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable Network Time Security authentication.
          Make sure it is supported by your selected NTP server(s).
        '';
      };

      initstepslew = {
        enabled = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Allow chronyd to make a rapid measurement of the system clock error
            at boot time, and to correct the system clock by stepping before
            normal operation begins.
          '';
        };

        threshold = mkOption {
          type = types.either types.float types.int;
          default = 1000; # by default, same threshold as 'ntpd -g' (1000s)
          description = lib.mdDoc ''
            The threshold of system clock error (in seconds) above which the
            clock will be stepped. If the correction required is less than the
            threshold, a slew is used instead.
          '';
        };
      };

      directory = mkOption {
        type = types.str;
        default = "/var/lib/chrony";
        description = lib.mdDoc "Directory where chrony state is stored.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Extra configuration directives that should be added to
          `chrony.conf`
        '';
      };

      extraFlags = mkOption {
        default = [];
        example = [ "-s" ];
        type = types.listOf types.str;
        description = lib.mdDoc "Extra flags passed to the chronyd command.";
      };
    };
  };

  config = mkIf cfg.enable {
    meta.maintainers = with lib.maintainers; [ thoughtpolice ];

    environment.systemPackages = [ chronyPkg ];

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
      "d ${stateDir} 0750 chrony chrony - -"
      "f ${driftFile} 0640 chrony chrony - -"
      "f ${keyFile} 0640 chrony chrony - -"
    ];

    systemd.services.chronyd =
      { description = "chrony NTP daemon";

        wantedBy = [ "multi-user.target" ];
        wants    = [ "time-sync.target" ];
        before   = [ "time-sync.target" ];
        after    = [ "network.target" "nss-lookup.target" ];
        conflicts = [ "ntpd.service" "systemd-timesyncd.service" ];

        path = [ chronyPkg ];

        unitConfig.ConditionCapability = "CAP_SYS_TIME";
        serviceConfig = {
          Type = "simple";
          ExecStart = "${chronyPkg}/bin/chronyd ${builtins.toString chronyFlags}";

          # Proc filesystem
          ProcSubset = "pid";
          ProtectProc = "invisible";
          # Access write directories
          ReadWritePaths = [ "${stateDir}" ];
          UMask = "0027";
          # Capabilities
          CapabilityBoundingSet = [ "CAP_CHOWN" "CAP_DAC_OVERRIDE" "CAP_NET_BIND_SERVICE" "CAP_SETGID" "CAP_SETUID" "CAP_SYS_RESOURCE" "CAP_SYS_TIME" ];
          # Device Access
          DeviceAllow = [ "char-pps rw" "char-ptp rw" "char-rtc rw" ];
          DevicePolicy = "closed";
          # Security
          NoNewPrivileges = true;
          # Sandboxing
          ProtectSystem = "full";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = false;
          PrivateUsers = false;
          ProtectHostname = true;
          ProtectClock = false;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          PrivateMounts = true;
          # System Call Filtering
          SystemCallArchitectures = "native";
          SystemCallFilter = [ "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @resources" "@clock" "@setuid" "capset" "@chown" ];
        };
      };
  };
}
