{
  lib,
  pkgs,
  config,
  ...
}:

with lib;

let
  cfg = config.services.evcc;

  format = pkgs.formats.yaml { };
  configFile = format.generate "evcc.yml" cfg.settings;

  package = pkgs.evcc;
in

{
  meta.maintainers = with lib.maintainers; [ hexa ];

  options.services.evcc = with types; {
    enable = mkEnableOption "EVCC, the extensible EV Charge Controller with PV integration";

    extraArgs = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Extra arguments to pass to the evcc executable.
      '';
    };

    settings = mkOption {
      type = format.type;
      description = ''
        evcc configuration as a Nix attribute set.

        Check for possible options in the sample [evcc.dist.yaml](https://github.com/andig/evcc/blob/${package.version}/evcc.dist.yaml].
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.evcc = {
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
        "mosquitto.target"
      ];
      wantedBy = [
        "multi-user.target"
      ];
      environment.HOME = "/var/lib/evcc";
      path = with pkgs; [
        getent
      ];
      serviceConfig = {
        ExecStart = "${package}/bin/evcc --config ${configFile} ${escapeShellArgs cfg.extraArgs}";
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [
          "char-ttyUSB"
        ];
        DevicePolicy = "closed";
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        Restart = "on-failure";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        StateDirectory = "evcc";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
        User = "evcc";
      };
    };
  };

  meta.buildDocsInSandbox = false;
}
