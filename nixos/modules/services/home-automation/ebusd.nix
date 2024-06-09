{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ebusd;
in
{
  meta.maintainers = with maintainers; [ nathan-gs ];

  options.services.ebusd = {
    enable = mkEnableOption "ebusd, a daemon for communication with eBUS heating systems";

    package = mkPackageOptionMD pkgs "ebusd" { };

    device = mkOption {
      type = types.str;
      default = "";
      example = "IP:PORT";
      description = ''
        Use DEV as eBUS device [/dev/ttyUSB0].
        This can be either:
          enh:DEVICE or enh:IP:PORT for enhanced device (only adapter v3 and newer),
          ens:DEVICE for enhanced high speed serial device (only adapter v3 and newer with firmware since 20220731),
          DEVICE for serial device (normal speed, for all other serial adapters like adapter v2 as well as adapter v3 in non-enhanced mode), or
          [udp:]IP:PORT for network device.

        Source: <https://github.com/john30/ebusd/wiki/2.-Run#device-options>
      '';
    };

    port = mkOption {
      default = 8888;
      type = types.port;
      description = ''
        The port on which to listen on
      '';
    };

    readonly = mkOption {
      type = types.bool;
      default = false;
      description = ''
         Only read from device, never write to it
      '';
    };

    configpath = mkOption {
      type = types.str;
      default = "https://cfg.ebusd.eu/";
      description = ''
        Directory to read CSV config files from. This can be a local folder or a URL.
      '';
    };

    scanconfig = mkOption {
      type = types.str;
      default = "full";
      description = ''
        Pick CSV config files matching initial scan ("none" or empty for no initial scan message, "full" for full scan, or a single hex address to scan, default is to send a broadcast ident message).
        If combined with --checkconfig, you can add scan message data as arguments for checking a particular scan configuration, e.g. "FF08070400/0AB5454850303003277201". For further details on this option,
        see [Automatic configuration](https://github.com/john30/ebusd/wiki/4.7.-Automatic-configuration).
      '';
    };

    logs = let
      # "all" must come first so it can be overridden by more specific areas
      areas = [ "all" "main" "network" "bus" "update" "other" ];
      levels = [ "none" "error" "notice" "info" "debug" ];
    in listToAttrs (map (area: nameValuePair area (mkOption {
      type = types.enum levels;
      default = "notice";
      example = "debug";
      description = ''
        Only write log for matching `AREA`s (${concatStringsSep "|" areas}) below or equal to `LEVEL` (${concatStringsSep "|" levels})
      '';
    })) areas);

    mqtt = {
      enable = mkEnableOption "support for MQTT";

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          Connect to MQTT broker on HOST.
        '';
      };

      port = mkOption {
        default = 1883;
        type = types.port;
        description = ''
          The port on which to connect to MQTT
        '';
      };

      home-assistant = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Adds the Home Assistant topics to MQTT, read more at [MQTT Integration](https://github.com/john30/ebusd/wiki/MQTT-integration)
        '';
      };

      retain = mkEnableOption "set the retain flag on all topics instead of only selected global ones";

      user = mkOption {
        type = types.str;
        description = ''
          The MQTT user to use
        '';
      };

      password = mkOption {
        type = types.str;
        description = ''
          The MQTT password.
        '';
      };
    };

    extraArguments = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        Extra arguments to the ebus daemon
      '';
    };
  };

  config = let
    usesDev = hasPrefix "/" cfg.device;
  in mkIf cfg.enable {
    systemd.services.ebusd = {
      description = "EBUSd Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = let
          args = cli.toGNUCommandLineShell { optionValueSeparator = "="; } (foldr (a: b: a // b) { } [
            {
              inherit (cfg) device port configpath scanconfig readonly;
              foreground = true;
              updatecheck = "off";
              log = mapAttrsToList (name: value: "${name}:${value}") cfg.logs;
              mqttretain = cfg.mqtt.retain;
            }
            (optionalAttrs cfg.mqtt.enable {
              mqtthost  = cfg.mqtt.host;
              mqttport  = cfg.mqtt.port;
              mqttuser  = cfg.mqtt.user;
              mqttpass  = cfg.mqtt.password;
            })
            (optionalAttrs cfg.mqtt.home-assistant {
              mqttint = "${cfg.package}/etc/ebusd/mqtt-hassio.cfg";
              mqttjson = true;
            })
          ]);
        in "${cfg.package}/bin/ebusd ${args} ${escapeShellArgs cfg.extraArguments}";

        DynamicUser = true;
        Restart = "on-failure";

        # Hardening
        CapabilityBoundingSet = "";
        DeviceAllow = optionals usesDev [ cfg.device ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = false;
        NoNewPrivileges = true;
        PrivateDevices = usesDev;
        PrivateUsers = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SupplementaryGroups = [ "dialout" ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service @pkey"
          "~@privileged @resources"
        ];
        UMask = "0077";
      };
    };
  };
}
