{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.chrony;
  chronyPkg = cfg.package;

  stateDir = cfg.directory;
  driftFile = "${stateDir}/chrony.drift";
  keyFile = "${stateDir}/chrony.keys";
  rtcFile = "${stateDir}/chrony.rtc";

  configFile = pkgs.writeText "chrony.conf" ''
    ${concatMapStringsSep "\n" (server: "server " + server + " " + cfg.serverOption + optionalString (cfg.enableNTS) " nts") cfg.servers}

    ${optionalString
      (cfg.initstepslew.enabled && (cfg.servers != []))
      "initstepslew ${toString cfg.initstepslew.threshold} ${concatStringsSep " " cfg.servers}"
    }

    driftfile ${driftFile}
    keyfile ${keyFile}
    ${optionalString (cfg.enableRTCTrimming) "rtcfile ${rtcFile}"}
    ${optionalString (cfg.enableNTS) "ntsdumpdir ${stateDir}"}

    ${optionalString (cfg.enableRTCTrimming) "rtcautotrim ${builtins.toString cfg.autotrimThreshold}"}
    ${optionalString (!config.time.hardwareClockInLocalTime) "rtconutc"}

    ${cfg.extraConfig}
  '';

  chronyFlags =
    [ "-n" "-u" "chrony" "-f" "${configFile}" ]
    ++ optional cfg.enableMemoryLocking "-m"
    ++ cfg.extraFlags;
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

      package = mkPackageOption pkgs "chrony" { };

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

      enableMemoryLocking = mkOption {
        type = types.bool;
        default = config.environment.memoryAllocator.provider != "graphene-hardened";
        defaultText = ''config.environment.memoryAllocator.provider != "graphene-hardened"'';
        description = lib.mdDoc ''
          Whether to add the `-m` flag to lock memory.
        '';
      };

      enableRTCTrimming = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Enable tracking of the RTC offset to the system clock and automatic trimming.
          See also [](#opt-services.chrony.autotrimThreshold)

          ::: {.note}
          This is not compatible with the `rtcsync` directive, which naively syncs the RTC time every 11 minutes.

          Tracking the RTC drift will allow more precise timekeeping,
          especially on intermittently running devices, where the RTC is very relevant.
          :::
        '';
      };

      autotrimThreshold = mkOption {
        type = types.ints.positive;
        default = 30;
        example = 10;
        description = ''
          Maximum estimated error threshold for the `rtcautotrim` command.
          When reached, the RTC will be trimmed.
          Only used when [](#opt-services.chrony.enableRTCTrimming) is enabled.
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
        default = [ ];
        example = [ "-s" ];
        type = types.listOf types.str;
        description = lib.mdDoc "Extra flags passed to the chronyd command.";
      };
    };
  };

  config = mkIf cfg.enable {
    meta.maintainers = with lib.maintainers; [ thoughtpolice vifino ];

    environment.systemPackages = [ chronyPkg ];

    users.groups.chrony.gid = config.ids.gids.chrony;

    users.users.chrony =
      {
        uid = config.ids.uids.chrony;
        group = "chrony";
        description = "chrony daemon user";
        home = stateDir;
      };

    services.timesyncd.enable = mkForce false;

    # If chrony controls and tracks the RTC, writing it externally causes clock error.
    systemd.services.save-hwclock = lib.mkIf cfg.enableRTCTrimming {
      enable = lib.mkForce false;
    };

    systemd.services.systemd-timedated.environment = { SYSTEMD_TIMEDATED_NTP_SERVICES = "chronyd.service"; };

    systemd.tmpfiles.rules = [
      "d ${stateDir} 0750 chrony chrony - -"
      "f ${driftFile} 0640 chrony chrony - -"
      "f ${keyFile} 0640 chrony chrony - -"
    ] ++ lib.optionals cfg.enableRTCTrimming [
      "f ${rtcFile} 0640 chrony chrony - -"
    ];

    systemd.services.chronyd =
      {
        description = "chrony NTP daemon";

        wantedBy = [ "multi-user.target" ];
        wants = [ "time-sync.target" ];
        before = [ "time-sync.target" ];
        after = [ "network.target" "nss-lookup.target" ];
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

    assertions = [
      {
        assertion = !(cfg.enableRTCTrimming && builtins.any (line: (builtins.match "^ *rtcsync" line) != null) (lib.strings.splitString "\n" cfg.extraConfig));
        message = ''
          The chrony module now configures `rtcfile` and `rtcautotrim` for you.
          These options conflict with `rtcsync` and cause chrony to crash.
          Unless you are very sure the former isn't what you want, please remove
          `rtcsync` from `services.chrony.extraConfig`.
          Alternatively, disable this behaviour by `services.chrony.enableRTCTrimming = false;`
        '';
      }
    ];
  };
}
