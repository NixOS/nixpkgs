{
  config,
  pkgs,
  lib,
  utils,
  ...
}:

let
  cfg = config.services.vlagent;

  startCLIList = [
    (lib.getExe cfg.package)
  ]
  ++ lib.optionals (cfg.remoteWrite.url != null) [
    "-remoteWrite.url=${cfg.remoteWrite.url}"
    "-remoteWrite.tmpDataPath=%C/vlagent/remote_write_tmp"
  ]
  ++ lib.optionals (cfg.remoteWrite.basicAuthPasswordFile != null) [
    "-remoteWrite.basicAuth.passwordFile=%d/remote_write_basic_auth_password"
  ]
  ++ lib.optionals (cfg.remoteWrite.basicAuthUsername != null) [
    "-remoteWrite.basicAuth.username=${cfg.remoteWrite.basicAuthUsername}"
  ]
  ++ lib.optionals (cfg.remoteWrite.maxDiskUsagePerUrl != null) [
    "-remoteWrite.maxDiskUsagePerUrl=${cfg.remoteWrite.maxDiskUsagePerUrl}"
  ];
in
{
  meta = {
    maintainers = [ lib.maintainers.shawn8901 ];
  };

  options.services.vlagent = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable VictoriaMetrics's `vlagent`.

        `vlagent` is a tiny agent which helps you collect logs from various sources and store them in VictoriaLogs .
      '';
    };

    package = lib.mkPackageOption pkgs "vlagent" { };

    remoteWrite = {
      url = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = ''
          Endpoint for the victorialogs instance
        '';
      };
      maxDiskUsagePerUrl = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = ''
          The maximum file-based buffer size in bytes. Supports the following optional suffixes for size values: KB, MB, GB, TB, KiB, MiB, GiB, TiB.
          See docs for more infomations: <https://docs.victoriametrics.com/vlagent.html#advanced-usage>
        '';
      };
      basicAuthUsername = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = ''
          Basic Auth username used to connect to remote_write endpoint
        '';
      };
      basicAuthPasswordFile = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = ''
          File that contains the Basic Auth password used to connect to remote_write endpoint
        '';
      };
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for the default ports.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Extra args to pass to `vlagent`. See the docs:
        <https://docs.victoriametrics.com/vlagent.html#advanced-usage>
        or {command}`vlagent -help` for more information.
      '';
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion =
          (cfg.remoteWrite.basicAuthUsername == null && cfg.remoteWrite.basicAuthPasswordFile == null)
          || (cfg.remoteWrite.basicAuthUsername != null && cfg.remoteWrite.basicAuthPasswordFile != null);
        message = "Both basicAuthUsername and basicAuthPasswordFile must be set together to enable basicAuth functionality, or neither should be set.";
      }
    ];

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ 9429 ];

    systemd.services.vlagent = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "vlagent system service";
      serviceConfig = {
        DynamicUser = true;
        User = "vlagent";
        Group = "vlagent";
        Type = "simple";
        Restart = "on-failure";
        CacheDirectory = "vlagent";
        ExecStart = lib.concatStringsSep " " [
          (lib.escapeShellArgs startCLIList)
          (utils.escapeSystemdExecArgs cfg.extraArgs)
        ];
        LoadCredential = lib.optional (
          cfg.remoteWrite.basicAuthPasswordFile != null
        ) "remote_write_basic_auth_password:${cfg.remoteWrite.basicAuthPasswordFile}";
      };
    };
  };
}
