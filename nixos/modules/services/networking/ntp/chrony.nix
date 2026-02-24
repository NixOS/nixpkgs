{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.chrony;
  chronyPkg = cfg.package;

  stateDir = cfg.directory;
  driftFile = "${stateDir}/chrony.drift";
  keyFile = "${stateDir}/chrony.keys";
  rtcFile = "${stateDir}/chrony.rtc";

  configFile = pkgs.writeText "chrony.conf" ''
    ${lib.concatMapStringsSep "\n" (
      server: "server " + server + " " + cfg.serverOption + lib.optionalString (cfg.enableNTS) " nts"
    ) cfg.servers}

    ${lib.optionalString (
      cfg.initstepslew.enabled && (cfg.servers != [ ])
    ) "initstepslew ${toString cfg.initstepslew.threshold} ${lib.concatStringsSep " " cfg.servers}"}

    driftfile ${driftFile}
    keyfile ${keyFile}
    ${lib.optionalString (cfg.enableRTCTrimming) "rtcfile ${rtcFile}"}
    ${lib.optionalString (cfg.enableNTS) "ntsdumpdir ${stateDir}"}

    ${lib.optionalString (cfg.enableRTCTrimming) "rtcautotrim ${builtins.toString cfg.autotrimThreshold}"}
    ${lib.optionalString (!config.time.hardwareClockInLocalTime) "rtconutc"}

    ${cfg.extraConfig}
  '';

  chronyFlags = [
    "-n"
    "-u"
    "chrony"
    "-f"
    "${configFile}"
  ]
  ++ lib.optional cfg.enableMemoryLocking "-m"
  ++ cfg.extraFlags;
in
{
  options = {
    services.chrony = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to synchronise your machine's time using chrony.
          Make sure you disable NTP if you enable this service.
        '';
      };

      package = lib.mkPackageOption pkgs "chrony" { };

      servers = lib.mkOption {
        default = config.networking.timeServers;
        defaultText = lib.literalExpression "config.networking.timeServers";
        type = lib.types.listOf lib.types.str;
        description = ''
          The set of NTP servers from which to synchronise.
        '';
      };

      serverOption = lib.mkOption {
        default = "iburst";
        type = lib.types.enum [
          "iburst"
          "offline"
        ];
        description = ''
          Set option for server directives.

          Use "iburst" to rapidly poll on startup. Recommended if your machine
          is consistently online.

          Use "offline" to prevent polling on startup. Recommended if your
          machine boots offline or is otherwise frequently offline.
        '';
      };

      enableMemoryLocking = lib.mkOption {
        type = lib.types.bool;
        default =
          config.environment.memoryAllocator.provider != "graphene-hardened"
          && config.environment.memoryAllocator.provider != "graphene-hardened-light";
        defaultText = lib.literalExpression ''config.environment.memoryAllocator.provider != "graphene-hardened" && config.environment.memoryAllocator.provider != "graphene-hardened-light"'';
        description = ''
          Whether to add the `-m` flag to lock memory.
        '';
      };

      enableRTCTrimming = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Enable tracking of the RTC offset to the system clock and automatic trimming.
          See also [](#opt-services.chrony.autotrimThreshold)

          ::: {.note}
          This is not compatible with the `rtcsync` directive, which naively syncs the RTC time every 11 minutes.

          Tracking the RTC drift will allow more precise timekeeping,
          especially on intermittently running devices, where the RTC is very relevant.
          :::
        '';
      };

      autotrimThreshold = lib.mkOption {
        type = lib.types.ints.positive;
        default = 30;
        example = 10;
        description = ''
          Maximum estimated error threshold for the `rtcautotrim` command.
          When reached, the RTC will be trimmed.
          Only used when [](#opt-services.chrony.enableRTCTrimming) is enabled.
        '';
      };

      enableNTS = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable Network Time Security authentication.
          Make sure it is supported by your selected NTP server(s).
        '';
      };

      initstepslew = {
        enabled = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = ''
            Allow chronyd to make a rapid measurement of the system clock error
            at boot time, and to correct the system clock by stepping before
            normal operation begins.
          '';
        };

        threshold = lib.mkOption {
          type = lib.types.either lib.types.float lib.types.int;
          default = 1000; # by default, same threshold as 'ntpd -g' (1000s)
          description = ''
            The threshold of system clock error (in seconds) above which the
            clock will be stepped. If the correction required is less than the
            threshold, a slew is used instead.
          '';
        };
      };

      directory = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/chrony";
        description = "Directory where chrony state is stored.";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration directives that should be added to
          `chrony.conf`
        '';
      };

      extraFlags = lib.mkOption {
        default = [ ];
        example = [ "-s" ];
        type = lib.types.listOf lib.types.str;
        description = "Extra flags passed to the chronyd command.";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    thoughtpolice
    vifino
  ];

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ chronyPkg ];

    users.groups.chrony.gid = config.ids.gids.chrony;

    users.users.chrony = {
      uid = config.ids.uids.chrony;
      group = "chrony";
      description = "chrony daemon user";
      home = stateDir;
    };

    services.timesyncd.enable = lib.mkForce false;

    # If chrony controls and tracks the RTC, writing it externally causes clock error.
    systemd.services.save-hwclock = lib.mkIf cfg.enableRTCTrimming {
      enable = lib.mkForce false;
    };

    systemd.services.systemd-timedated.environment = {
      SYSTEMD_TIMEDATED_NTP_SERVICES = "chronyd.service";
    };

    systemd.tmpfiles.rules = [
      "d ${stateDir} 0750 chrony chrony - -"
      "f ${driftFile} 0640 chrony chrony - -"
      "f ${keyFile} 0640 chrony chrony - -"
    ]
    ++ lib.optionals cfg.enableRTCTrimming [
      "f ${rtcFile} 0640 chrony chrony - -"
    ];

    systemd.services.chronyd = {
      description = "chrony NTP daemon";

      wantedBy = [ "multi-user.target" ];
      wants = [ "time-sync.target" ];
      before = [ "time-sync.target" ];
      after = [
        "network.target"
        "nss-lookup.target"
      ];
      conflicts = [
        "ntpd.service"
        "systemd-timesyncd.service"
      ];

      path = [ chronyPkg ];

      unitConfig = lib.mkIf (!lib.elem "-x" cfg.extraFlags && !cfg.enableRTCTrimming) {
        ConditionCapability = "CAP_SYS_TIME";
      };
      serviceConfig = {
        Type = "notify";
        ExecStart = "${chronyPkg}/bin/chronyd ${builtins.toString chronyFlags}";

        # Proc filesystem
        ProcSubset = "pid";
        ProtectProc = "invisible";
        # Access write directories
        ReadWritePaths = [ "${stateDir}" ];
        UMask = "0027";
        # Capabilities
        CapabilityBoundingSet = [
          "CAP_CHOWN"
          "CAP_DAC_OVERRIDE"
          "CAP_NET_BIND_SERVICE"
          "CAP_SETGID"
          "CAP_SETUID"
          "CAP_SYS_RESOURCE"
          "CAP_SYS_TIME"
        ];
        # Device Access
        DeviceAllow = [
          "char-pps rw"
          "char-ptp rw"
          "char-rtc rw"
        ];
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
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@cpu-emulation @debug @keyring @mount @obsolete @privileged @resources"
          "@clock"
          "@setuid"
          "capset"
          "@chown"
        ];
      };
    };

    assertions = [
      {
        assertion =
          !(
            cfg.enableRTCTrimming
            && builtins.any (line: (builtins.match "^ *rtcsync" line) != null) (
              lib.strings.splitString "\n" cfg.extraConfig
            )
          );
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
