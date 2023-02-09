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
    enable = mkEnableOption (lib.mdDoc "Envoy reverse proxy");

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
        CacheDirectory = [ "envoy" ];
        LogsDirectory = [ "envoy" ];
        Restart = "no";
        # Hardening
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        DynamicUser = true;
        LockPersonality = true;
        PrivateDevices = true;
        PrivateUsers = false; # breaks CAP_NET_BIND_SERVICE
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
        SystemCallFilter = [ "~@clock" "~@module" "~@mount" "~@reboot" "~@swap" "~@obsolete" "~@cpu-emulation" ];
        UMask = "0066";
      };
    };
  };
}
