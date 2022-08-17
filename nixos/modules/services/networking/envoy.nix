{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.envoy;
  format = pkgs.formats.json { };
  conf = format.generate "envoy.json" cfg.settings;
  validateConfig = file:
    pkgs.runCommand "validate-envoy-conf" { } ''
      ${pkgs.envoy}/bin/envoy --log-level error --mode validate -c "${file}"
      cp "${file}" "$out"
    '';

in

{
  options.services.envoy = {
    enable = mkEnableOption "Envoy reverse proxy";

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
      description = lib.mdDoc ''
        Specify the configuration for Envoy in Nix.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.envoy ];
    systemd.services.envoy = {
      description = "Envoy reverse proxy";
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.envoy}/bin/envoy -c ${validateConfig conf}";
        DynamicUser = true;
        Restart = "no";
        CacheDirectory = "envoy";
        LogsDirectory = "envoy";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6 AF_NETLINK AF_XDP";
        SystemCallArchitectures = "native";
        LockPersonality = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        PrivateUsers = false;  # breaks CAP_NET_BIND_SERVICE
        PrivateDevices = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "ptraceable";
        ProtectHostname = true;
        ProtectSystem = "strict";
        UMask = "0066";
        SystemCallFilter = "~@clock @module @mount @reboot @swap @obsolete @cpu-emulation";
      };
    };
  };
}
