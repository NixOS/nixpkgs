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

      package = mkOption {
        type = types.package;
        default = pkgs.chrony;
        defaultText = "pkgs.chrony";
        description = ''
          Which chrony package to use.
        '';
      };

      servers = mkOption {
        default = config.networking.timeServers;
        type = types.listOf types.str;
        description = ''
          The set of NTP servers from which to synchronise.
        '';
      };

      serverOption = mkOption {
        default = "iburst";
        type = types.enum [ "iburst" "offline" ];
        description = ''
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
        description = ''
          Whether to enable Network Time Security authentication.
          Make sure it is supported by your selected NTP server(s).
        '';
      };

      initstepslew = mkOption {
        type = types.attrsOf (types.either types.bool types.int);
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

      directory = mkOption {
        type = types.str;
        default = "/var/lib/chrony";
        description = "Directory where chrony state is stored.";
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

        path = [ chronyPkg ];

        unitConfig.ConditionCapability = "CAP_SYS_TIME";
        serviceConfig =
          { Type = "simple";
            ExecStart = "${chronyPkg}/bin/chronyd ${chronyFlags}";

            ProtectHome = "yes";
            ProtectSystem = "full";
            PrivateTmp = "yes";
          };

      };
  };
}
