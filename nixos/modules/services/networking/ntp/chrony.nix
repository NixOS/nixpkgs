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

  chronyWaitSyncFlags = concatStringsSep " "
    [ (toString cfg.bootAdjustmentOptions.maxTries)
      (toString cfg.bootAdjustmentOptions.maxCorrection)
      (toString cfg.bootAdjustmentOptions.maxSkew)
      (toString cfg.bootAdjustmentOptions.interval)
    ];
in
{
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
        };
        description = ''
          Allow chronyd to make a rapid measurement of the system clock error at
          boot time, and to correct the system clock by stepping before normal
          operation begins.
        '';
      };

      bootAdjustmentOptions = mkOption {
        default = {
          maxTries = 12;
          maxCorrection = 0;
          maxSkew = 0;
          interval = 5;
        };
        description = ''
          Parameters for initial boot-time synchronization. By default, once
          Chrony starts at boot, it will attempt to do rapid adjustments of the
          system time in order to get the clock within a measured threshold.
          Once this has been achieved, the systemd service
          <literal>time-sync.target</literal> will be activated. These
          parameters control the timeout for waiting on initial NTP
          synchronization. By default, Chrony will wait for 1 minute while
          attempting to adjust the initial time at boot.
        '';
      };

      skipInitialAdjustment = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If set to <literal>true</literal>, then the default NTP adjustment at
          boot will be skipped. This is useful in some advanced situations,
          such as using a 'local stratum' clock in offline networks, where
          <literal>chronyc waitsync</literal> may never return.
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
        example = [ "-s" "-F1" ];
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

    systemd.services.chronyd =
      { description   = "Chrony NTP daemon";
        documentation = [ "man:chronyd(8)" "man:chrony.conf(5)" "https://chrony.tuxfamily.org" ];

        wantedBy  = [ "multi-user.target" ];
        wants     = [ "ntp-adjusted-chrony.service" ];
        after     = [ "network.target" ];
        conflicts = [ "openntpd.service" "ntpd.service" "systemd-timesyncd.service" ];

        preStart = ''
          mkdir -m 0755 -p ${stateDir}
          touch ${keyFile}
          chmod 0640 ${keyFile}
          chown chrony:chrony ${stateDir} ${keyFile}
        '';

        unitConfig.ConditionCapability = "CAP_SYS_TIME";
        serviceConfig =
          { Type = "simple";
            ExecStart = "${pkgs.chrony}/bin/chronyd ${chronyFlags}";

            ProtectHome = "yes";
            ProtectSystem = "full";
            PrivateTmp = "yes";
          };
      };

    # Blocker for time-sync.target
    systemd.services.ntp-adjusted-chrony =
      { description = "initial NTP adjustment and measurement (chrony)";

        requires = [ "chronyd.service" "time-sync.target" ];
        before   = [ "time-sync.target" ];
        after    = [ "chronyd.service" ];

        serviceConfig =
          { ExecStart =
              if cfg.skipInitialAdjustment
                then "${pkgs.coreutils}/bin/true"
                else "${pkgs.chrony}/bin/chronyc waitsync ${chronyWaitSyncFlags}";

            Type = "oneshot";
            RemainAfterExit = "yes";

            ProtectHome = "yes";
            ProtectSystem = "full";
            PrivateTmp = "yes";
          };
      };
  };
}
