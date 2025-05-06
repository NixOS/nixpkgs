{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib)
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    ;

  cfg = config.services.evcc;

  format = pkgs.formats.yaml { };
  configFile = format.generate "evcc.yml" cfg.settings;

  package = pkgs.evcc;
in

{
  meta.maintainers = with lib.maintainers; [ hexa ];

  options.services.evcc = with lib.types; {
    enable = mkEnableOption "EVCC, the extensible EV Charge Controller and Home Energy Management System";

    package = mkPackageOption pkgs "evcc" { };

    extraArgs = mkOption {
      type = listOf str;
      default = [ ];
      description = ''
        Extra arguments to pass to the `evcc` executable.
      '';
    };

    environmentFile = mkOption {
      type = nullOr path;
      default = null;
      example = /run/keys/evcc;
      description = ''
        File with environment variables to pass into the runtime environment.

        Useful to pass secrets into the configuration, that get applied using `envsubst`.
      '';
    };

    settings = mkOption {
      type = format.type;
      description = ''
        evcc configuration as a Nix attribute set. Supports substitution of secrets using `envsubst` from the `environmentFile`.

        Check for possible options in the sample [evcc.dist.yaml](https://github.com/andig/evcc/blob/${package.version}/evcc.dist.yaml).
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
        EnvironmentFile = lib.optionals (cfg.environmentFile != null) [ cfg.environmentFile ];
        ExecStartPre = utils.escapeSystemdExecArgs [
          (getExe pkgs.envsubst)
          "-i"
          configFile
          "-o"
          "/run/evcc/config.yaml"
        ];
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (getExe cfg.package)
            "--config=/run/evcc/config.yaml"
          ]
          ++ cfg.extraArgs
        );
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [
          "char-ttyUSB"
        ];
        DevicePolicy = "closed";
        DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
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
        Restart = "on-failure";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RuntimeDirectory = "evcc";
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
