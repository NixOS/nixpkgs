{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.promtail;

  format = pkgs.formats.json { };
  prettyJSON =
    conf:
    with lib;
    pipe conf [
      (flip removeAttrs [ "_module" ])
      (format.generate "promtail-config.json")
    ];

  allowSystemdJournal =
    cfg.configuration ? scrape_configs && lib.any (v: v ? journal) cfg.configuration.scrape_configs;

  allowPositionsFile = !lib.hasPrefix "/var/cache/promtail" positionsFile;
  positionsFile = cfg.configuration.positions.filename;

  configFile = if cfg.configFile != null then cfg.configFile else prettyJSON cfg.configuration;

in
{
  options.services.promtail = with types; {
    enable = mkEnableOption "the Promtail ingresser";

    configuration = mkOption {
      type = format.type;
      description = ''
        Specify the configuration for Promtail in Nix.
        This option will be ignored if `services.promtail.configFile` is defined.
      '';
    };

    configFile = mkOption {
      type = nullOr path;
      default = null;
      description = ''
        Config file path for Promtail.
        If this option is defined, the value of `services.promtail.configuration` will be ignored.
      '';
    };

    extraFlags = mkOption {
      type = listOf str;
      default = [ ];
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

      preStart = ''
        ${lib.getExe pkgs.promtail} -config.file=${configFile} -check-syntax
      '';

      serviceConfig = {
        Restart = "on-failure";
        TimeoutStopSec = 10;

        ExecStart = "${pkgs.promtail}/bin/promtail -config.file=${configFile} ${escapeShellArgs cfg.extraFlags}";

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

        SupplementaryGroups = lib.optional allowSystemdJournal "systemd-journal";
      }
      // (optionalAttrs (!pkgs.stdenv.hostPlatform.isAarch64) {
        # FIXME: figure out why this breaks on aarch64
        SystemCallFilter = "@system-service";
      });
    };

    users.groups.promtail = { };
    users.users.promtail = {
      description = "Promtail service user";
      isSystemUser = true;
      group = "promtail";
    };
  };
}
