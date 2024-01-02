{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ebusd;

  package = pkgs.ebusd;

  arguments = [
    "${package}/bin/ebusd"
    "--foreground"
    "--updatecheck=off"
    "--device=${cfg.device}"
    "--port=${toString cfg.port}"
    "--configpath=${cfg.configpath}"
    "--scanconfig=${cfg.scanconfig}"
    "--log=main:${cfg.logs.main}"
    "--log=network:${cfg.logs.network}"
    "--log=bus:${cfg.logs.bus}"
    "--log=update:${cfg.logs.update}"
    "--log=other:${cfg.logs.other}"
    "--log=all:${cfg.logs.all}"
  ] ++ lib.optionals cfg.readonly [
    "--readonly"
  ] ++ lib.optionals cfg.mqtt.enable [
    "--mqtthost=${cfg.mqtt.host}"
    "--mqttport=${toString cfg.mqtt.port}"
    "--mqttuser=${cfg.mqtt.user}"
    "--mqttpass=${cfg.mqtt.password}"
  ] ++ lib.optionals cfg.mqtt.home-assistant [
    "--mqttint=${package}/etc/ebusd/mqtt-hassio.cfg"
    "--mqttjson"
  ] ++ lib.optionals cfg.mqtt.retain [
    "--mqttretain"
  ] ++ cfg.extraArguments;

  usesDev = hasPrefix "/" cfg.device;

  command = concatStringsSep " " arguments;

in
{
  meta.maintainers = with maintainers; [ nathan-gs ];

  options.services.ebusd = {
    enable = mkEnableOption (lib.mdDoc "ebusd service");

    device = mkOption {
      type = types.str;
      default = "";
      example = "IP:PORT";
      description = lib.mdDoc ''
        Use DEV as eBUS device [/dev/ttyUSB0].
        This can be either:
          enh:DEVICE or enh:IP:PORT for enhanced device (only adapter v3 and newer),
          ens:DEVICE for enhanced high speed serial device (only adapter v3 and newer with firmware since 20220731),
          DEVICE for serial device (normal speed, for all other serial adapters like adapter v2 as well as adapter v3 in non-enhanced mode), or
          [udp:]IP:PORT for network device.
        https://github.com/john30/ebusd/wiki/2.-Run#device-options
      '';
    };

    port = mkOption {
      default = 8888;
      type = types.port;
      description = lib.mdDoc ''
        The port on which to listen on
      '';
    };

    readonly = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
         Only read from device, never write to it
      '';
    };

    configpath = mkOption {
      type = types.str;
      default = "https://cfg.ebusd.eu/";
      description = lib.mdDoc ''
        Read CSV config files from PATH (local folder or HTTPS URL) [https://cfg.ebusd.eu/]
      '';
    };

    scanconfig = mkOption {
      type = types.str;
      default = "full";
      description = lib.mdDoc ''
        Pick CSV config files matching initial scan ("none" or empty for no initial scan message, "full" for full scan, or a single hex address to scan, default is to send a broadcast ident message).
        If combined with --checkconfig, you can add scan message data as arguments for checking a particular scan configuration, e.g. "FF08070400/0AB5454850303003277201". For further details on this option,
        see [Automatic configuration](https://github.com/john30/ebusd/wiki/4.7.-Automatic-configuration).
      '';
    };

    logs = {
      main = mkOption {
        type = types.enum [ "error" "notice" "info" "debug"];
        default = "info";
        description = lib.mdDoc ''
          Only write log for matching AREAs (main|network|bus|update|other|all) below or equal to LEVEL (error|notice|info|debug) [all:notice].
        '';
      };

      network = mkOption {
        type = types.enum [ "error" "notice" "info" "debug"];
        default = "info";
        description = lib.mdDoc ''
          Only write log for matching AREAs (main|network|bus|update|other|all) below or equal to LEVEL (error|notice|info|debug) [all:notice].
        '';
      };

      bus = mkOption {
        type = types.enum [ "error" "notice" "info" "debug"];
        default = "info";
        description = lib.mdDoc ''
          Only write log for matching AREAs (main|network|bus|update|other|all) below or equal to LEVEL (error|notice|info|debug) [all:notice].
        '';
      };

      update = mkOption {
        type = types.enum [ "error" "notice" "info" "debug"];
        default = "info";
        description = lib.mdDoc ''
          Only write log for matching AREAs (main|network|bus|update|other|all) below or equal to LEVEL (error|notice|info|debug) [all:notice].
        '';
      };

      other = mkOption {
        type = types.enum [ "error" "notice" "info" "debug"];
        default = "info";
        description = lib.mdDoc ''
          Only write log for matching AREAs (main|network|bus|update|other|all) below or equal to LEVEL (error|notice|info|debug) [all:notice].
        '';
      };

      all = mkOption {
        type = types.enum [ "error" "notice" "info" "debug"];
        default = "info";
        description = lib.mdDoc ''
          Only write log for matching AREAs (main|network|bus|update|other|all) below or equal to LEVEL (error|notice|info|debug) [all:notice].
        '';
      };
    };

    mqtt = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Adds support for MQTT
        '';
      };

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = lib.mdDoc ''
          Connect to MQTT broker on HOST.
        '';
      };

      port = mkOption {
        default = 1883;
        type = types.port;
        description = lib.mdDoc ''
          The port on which to connect to MQTT
        '';
      };

      home-assistant = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Adds the Home Assistant topics to MQTT, read more at [MQTT Integration](https://github.com/john30/ebusd/wiki/MQTT-integration)
        '';
      };

      retain = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Set the retain flag on all topics instead of only selected global ones
        '';
      };

      user = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The MQTT user to use
        '';
      };

      password = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The MQTT password.
        '';
      };

    };

    extraArguments = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
        Extra arguments to the ebus daemon
      '';
    };

  };

  config = mkIf (cfg.enable) {

    systemd.services.ebusd = {
      description = "EBUSd Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = command;
        DynamicUser = true;
        Restart = "on-failure";

        # Hardening
        CapabilityBoundingSet = "";
        DeviceAllow = lib.optionals usesDev [
          cfg.device
        ] ;
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
        SupplementaryGroups = [
          "dialout"
        ];
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
