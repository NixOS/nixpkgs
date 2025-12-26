{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    literalExpression
    maintainers
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  cfg = config.services.esphome;

  stateDir = "/var/lib/esphome";

  esphomeParams =
    if cfg.enableUnixSocket then
      "--socket /run/esphome/esphome.sock"
    else
      "--address ${cfg.address} --port ${toString cfg.port}";
in
{
  meta.maintainers = with maintainers; [ oddlama ];

  options.services.esphome = {
    enable = mkEnableOption "esphome, for making custom firmwares for ESP32/ESP8266";

    package = lib.mkPackageOption pkgs "esphome" { };

    enableUnixSocket = mkOption {
      type = types.bool;
      default = false;
      description = "Listen on a unix socket `/run/esphome/esphome.sock` instead of the TCP port.";
    };

    address = mkOption {
      type = types.str;
      default = "localhost";
      description = "esphome address";
    };

    port = mkOption {
      type = types.port;
      default = 6052;
      description = "esphome port";
    };

    openFirewall = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to open the firewall for the specified port.";
    };

    allowedDevices = mkOption {
      default = [
        "char-ttyS"
        "char-ttyUSB"
      ];
      example = [
        "/dev/serial/by-id/usb-Silicon_Labs_CP2102_USB_to_UART_Bridge_Controller_0001-if00-port0"
      ];
      description = ''
        A list of device nodes to which {command}`esphome` has access to.
        Refer to DeviceAllow in {manpage}`systemd.resource-control(5)` for more information.
        Beware that if a device is referred to by an absolute path instead of a device category,
        it will only allow devices that already are plugged in when the service is started.
      '';
      type = types.listOf types.str;
    };

    usePing = mkOption {
      default = false;
      type = types.bool;
      description = "Use ping to check online status of devices instead of mDNS";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf (cfg.openFirewall && !cfg.enableUnixSocket) [ cfg.port ];

    systemd.services.esphome = {
      description = "ESPHome dashboard";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];

      environment = {
        # platformio fails to determine the home directory when using DynamicUser
        PLATFORMIO_CORE_DIR = "${stateDir}/.platformio";
      }
      // lib.optionalAttrs cfg.usePing { ESPHOME_DASHBOARD_USE_PING = "true"; };

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/esphome dashboard ${esphomeParams} ${stateDir}";
        DynamicUser = true;
        User = "esphome";
        Group = "esphome";
        WorkingDirectory = stateDir;
        StateDirectory = "esphome";
        StateDirectoryMode = "0750";
        Restart = "on-failure";
        RuntimeDirectory = mkIf cfg.enableUnixSocket "esphome";
        RuntimeDirectoryMode = "0750";

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        DevicePolicy = "closed";
        DeviceAllow = map (d: "${d} rw") cfg.allowedDevices;
        SupplementaryGroups = [ "dialout" ];
        #NoNewPrivileges = true; # Implied by DynamicUser
        PrivateUsers = true;
        #PrivateTmp = true; # Implied by DynamicUser
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = false; # breaks bwrap
        ProtectKernelLogs = false; # breaks bwrap
        ProtectKernelModules = true;
        ProtectKernelTunables = false; # breaks bwrap
        ProtectProc = "invisible";
        ProcSubset = "all"; # Using "pid" breaks bwrap
        ProtectSystem = "strict";
        #RemoveIPC = true; # Implied by DynamicUser
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        RestrictNamespaces = false; # Required by platformio for chroot
        RestrictRealtime = true;
        #RestrictSUIDSGID = true; # Implied by DynamicUser
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@mount" # Required by platformio for chroot
        ];
        UMask = "0077";
      };
    };
  };
}
