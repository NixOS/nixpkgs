{ config, lib, pkgs, ... }: with lib;
let
  cfg = config.services.promtail;

  prettyJSON = conf: pkgs.runCommandLocal "promtail-config.json" {} ''
    echo '${builtins.toJSON conf}' | ${pkgs.buildPackages.jq}/bin/jq 'del(._module)' > $out
  '';

in {
  options.services.promtail = with types; {
    enable = mkEnableOption "the Promtail ingresser";

    configuration = mkOption {
      type = with lib.types; let
        valueType = nullOr (oneOf [
          bool
          int
          float
          str
          (lazyAttrsOf valueType)
          (listOf valueType)
        ]) // {
          description = "JSON value";
          emptyValue.value = {};
          deprecationMessage = null;
        };
      in valueType;
      description = ''
        Specify the configuration for Promtail in Nix.
      '';
    };

    extraFlags = mkOption {
      type = listOf str;
      default = [];
      example = [ "--server.http-listen-port=3101" ];
      description = ''
        Specify a list of additional command line flags,
        which get escaped and are then passed to Loki.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.promtail.configuration.positions.filename = mkDefault "/var/cache/promtail/positions.yaml";

    systemd.services.promtail = {
      description = "Promtail log ingress";
      wantedBy = [ "multi-user.target" ];
      stopIfChanged = false;

      serviceConfig = {
        Restart = "on-failure";

        ExecStart = "${pkgs.grafana-loki}/bin/promtail -config.file=${prettyJSON cfg.configuration} ${escapeShellArgs cfg.extraFlags}";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        CacheDirectory = "promtail";

        User = "promtail";
        Group = "promtail";

        CapabilityBoundingSet = "";
        NoNewPrivileges = true;

        ProtectKernelModules = true;
        SystemCallArchitectures = "native";
        ProtectKernelLogs = true;
        ProtectClock = true;

        LockPersonality = true;
        ProtectHostname = true;
        RestrictRealtime = true;
        MemoryDenyWriteExecute = true;
        PrivateUsers = true;
      } // (optionalAttrs (!pkgs.stdenv.isAarch64) { # FIXME: figure out why this breaks on aarch64
        SystemCallFilter = "@system-service";
      });
    };

    users.groups.promtail = {};
    users.users.promtail = {
      description = "Promtail service user";
      isSystemUser = true;
      group = "promtail";
    };
  };
}
