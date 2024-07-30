{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.envoy;
  format = pkgs.formats.json { };
  conf = format.generate "envoy.json" cfg.settings;
  validateConfig = required: file:
    pkgs.runCommand "validate-envoy-conf" { } ''
      ${cfg.package}/bin/envoy --log-level error --mode validate -c "${file}" ${lib.optionalString (!required) "|| true"}
      cp "${file}" "$out"
    '';
in

{
  options.services.envoy = {
    enable = mkEnableOption "Envoy reverse proxy";

    package = mkPackageOption pkgs "envoy" { };

    requireValidConfig = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether a failure during config validation at build time is fatal.
        When the config can't be checked during build time, for example when it includes
        other files, disable this option.
      '';
    };

    settings = mkOption {
      type = format.type;
      default = { };
      example = literalExpression ''
        {
          admin = {
            access_log_path = "/dev/null";
            address = {
              socket_address = {
                protocol = "TCP";
                address = "127.0.0.1";
                port_value = 9901;
              };
            };
          };
          static_resources = {
            listeners = [];
            clusters = [];
          };
        }
      '';
      description = ''
        Specify the configuration for Envoy in Nix.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.services.envoy = {
      description = "Envoy reverse proxy";
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/envoy -c ${validateConfig cfg.requireValidConfig conf}";
        CacheDirectory = [ "envoy" ];
        LogsDirectory = [ "envoy" ];
        Restart = "no";
        # Hardening
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        DeviceAllow = [ "" ];
        DevicePolicy = "closed";
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = false; # at least wasmr needs WX permission
        PrivateDevices = true;
        PrivateUsers = false; # breaks CAP_NET_BIND_SERVICE
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "ptraceable";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" "AF_NETLINK" "AF_XDP" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [ "@system-service" "~@privileged" "~@resources" ];
        UMask = "0066";
      };
    };
  };
}
