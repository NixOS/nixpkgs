{ config, lib, pkgs, ... }: with lib;
let
  cfg = config.services.promtail;

  prettyJSON = conf: pkgs.runCommandLocal "promtail-config.json" {} ''
    echo '${builtins.toJSON conf}' | ${pkgs.buildPackages.jq}/bin/jq 'del(._module)' > $out
  '';

  allowSystemdJournal = cfg.configuration ? scrape_configs && lib.any (v: v ? journal) cfg.configuration.scrape_configs;

  allowPositionsFile = !lib.hasPrefix "/var/cache/promtail" positionsFile;
  positionsFile = cfg.configuration.positions.filename;
in {
  options.services.promtail = with types; {
    enable = mkEnableOption (lib.mdDoc "the Promtail ingresser");


    configuration = mkOption {
      type = (pkgs.formats.json {}).type;
      description = lib.mdDoc ''
        Specify the configuration for Promtail in Nix.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Environment file as defined in {manpage}`systemd.exec(5)`.

        Secrets may be passed to the service without adding them to Nix store.
        You can use environment variable references in the configuration by
        adding `-config.expand-env=true` to `extraFlags` and use `\''${VAR}` in
        the configuration.

        ```
        clients = [{
          url = "https://\''${GRAFANA_API_KEY}@logs-prod-011.grafana.net/api/prom/push";
        }];
        ```
      '';
    };

    extraFlags = mkOption {
      type = listOf str;
      default = [];
      example = [ "--server.http-listen-port=3101" ];
      description = lib.mdDoc ''
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
        TimeoutStopSec = 10;

        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = "${pkgs.promtail}/bin/promtail -config.file=${prettyJSON cfg.configuration} ${escapeShellArgs cfg.extraFlags}";

        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        CacheDirectory = "promtail";
        ReadWritePaths = lib.optional allowPositionsFile (builtins.dirOf positionsFile);

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

        SupplementaryGroups = lib.optional (allowSystemdJournal) "systemd-journal";
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
