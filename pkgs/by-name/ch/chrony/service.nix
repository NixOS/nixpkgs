# Non-module dependencies (`importApply`)
{ writeText }:

# Service module
{
  lib,
  config,
  options,
  ...
}:

let
  inherit (lib) mkOption mkEnableOption types;
  cfg = config.chrony;

  stateDir = cfg.directory;
  driftFile = "${stateDir}/chrony.drift";
  keyFile = "${stateDir}/chrony.keys";
  rtcFile = "${stateDir}/chrony.rtc";

  configFile = writeText "chrony.conf" ''
    ${lib.concatMapStringsSep "\n" (
      server:
      (if lib.strings.hasInfix "pool" server then "pool " else "server ")
      + server
      + " "
      + cfg.serverOption
      + lib.optionalString (cfg.enableNTS) " nts"
    ) cfg.servers}

    ${lib.optionalString cfg.makestep.enable "makestep ${toString cfg.makestep.threshold} ${toString cfg.makestep.limit}"}

    driftfile ${driftFile}
    keyfile ${keyFile}
    ${lib.optionalString (cfg.enableRTCTrimming) "rtcfile ${rtcFile}"}
    ${lib.optionalString (cfg.enableNTS) "ntsdumpdir ${stateDir}"}

    ${lib.optionalString (cfg.enableRTCTrimming) "rtcautotrim ${toString cfg.autotrimThreshold}"}

    ${cfg.extraConfig}
  '';
in

{
  # https://nixos.org/manual/nixos/unstable/#modular-services
  _class = "service";
  options.chrony = {
    package = mkOption {
      description = "Package to use for ghostunnel";
      defaultText = "The ghostunnel package that provided this module.";
      type = types.package;
    };

    serverOption = mkOption {
      default = "iburst";
      type = types.enum [
        "iburst"
        "offline"
      ];
      description = ''
        Set option for server directives.

        Use “iburst” to rapidly poll on startup. Recommended if your machine is consistently online.
        Use “offline” to prevent polling on startup. Recommended if your machine boots offline or is otherwise frequently offline.
      '';
    };

    enableNTS = mkEnableOption "Network Time Security authentication. Make sure it is supported by your selected NTP server(s).";

    servers = mkOption {
      description = "The set of NTP servers from which to synchronise.";
      type = types.listOf (types.str);
    };

    enableMemoryLocking = lib.mkOption {
      type = lib.types.bool;
      defualt = false;
      description = ''
        Whether to add the `-m` flag to lock memory.
      '';
    };

    enableRTCTrimming = mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable tracking of the RTC offset to the system clock and automatic trimming.
        See also [](#modular-services.chrony.autotrimThreshold)

        ::: {.note}
        This is not compatible with the `rtcsync` directive, which naively syncs the RTC time every 11 minutes.

        Tracking the RTC drift will allow more precise timekeeping,
        especially on intermittently running devices, where the RTC is very relevant.
        :::
      '';
    };

    autotrimThreshold = mkOption {
      type = lib.types.ints.positive;
      default = 30;
      example = 10;
      description = ''
        Maximum estimated error threshold for the `rtcautotrim` command.
        When reached, the RTC will be trimmed.
        Only used when [](#modular-services.chrony.enableRTCTrimming) is enabled.
      '';
    };

    makestep = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Allow chronyd to step the system clock if the error is larger than
          the specified threshold.
        '';
      };

      threshold = mkOption {
        type = types.either types.float lib.types.int;
        default = 0.1;
        description = ''
          The threshold of system clock error (in seconds) above which the
          clock will be stepped. If the correction required is less than the
          threshold, a slew is used instead.
        '';
      };

      limit = mkOption {
        type = types.ints.positive;
        default = 3;
        description = ''
          The maximum number of times the system clock will be stepped.
        '';
      };
    };

    directory = mkOption {
      type = lib.types.str;
      default = "/var/lib/chrony";
      description = "Directory where chrony state is stored.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration directives that should be added to
        {file}`chrony.conf`
      '';
    };
  };

  config = {
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

    notificationProtocol = [
      "systemd"
      # Wait for upstream to add s6 support.
    ];
    process.argv = [
      "${cfg.package}/bin"
      "-n"
      "-u"
      ""
      configFile
    ];
  }
  // lib.optionalAttrs (options ? systemd) {
    systemd.tmpfiles.rules = [
      "d ${stateDir} 0750 chrony chrony - -"
      "f ${driftFile} 0640 chrony chrony - -"
      "f ${keyFile} 0640 root chrony - -"
    ]
    ++ lib.optionals cfg.enableRTCTrimming [
      "f ${rtcFile} 0640 chrony chrony - -"
    ];

    systemd.service = {
      wants = [ "time-sync.target" ];
      before = [ "time-sync.target" ];
      conflicts = [
        "ntpd.service"
        "systemd-timesyncd.service"
      ];

      unitConfig = lib.mkIf (!lib.elem "-x" cfg.extraFlags && !cfg.enableRTCTrimming) {
        ConditionCapability = "CAP_SYS_TIME";
      };

    };
  }
  // lib.optionalAttrs (options ? finit) {
    finit.tmpfiles.rules = [
      "d ${stateDir} 0750 chrony chrony - -"
      "f ${driftFile} 0640 chrony chrony - -"
      "f ${keyFile} 0640 root chrony - -"
    ]
    ++ lib.optionals cfg.enableRTCTrimming [
      "f ${rtcFile} 0640 chrony chrony - -"
    ];
  };

  meta.maintainers = with lib.maintainers; [
    eveeifyeve
  ];
}
