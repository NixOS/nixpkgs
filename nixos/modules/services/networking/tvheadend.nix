{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.tvheadend;
in
{
  options.services.tvheadend = {
    enable = lib.mkEnableOption "Tvheadend TV streaming server";

    package = lib.mkPackageOption pkgs "tvheadend" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "tvheadend";
      description = "User account under which Tvheadend runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "tvheadend";
      description = "Group under which Tvheadend runs.";
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "video" ];
      example = [
        "video"
        "dvb"
      ];
      description = "Additional groups for the systemd service.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/tvheadend";
      description = "Directory where Tvheadend stores its configuration and data.";
    };

    httpPort = lib.mkOption {
      type = lib.types.port;
      default = 9981;
      description = "Port to bind HTTP to.";
    };

    htspPort = lib.mkOption {
      type = lib.types.port;
      default = 9982;
      description = "Port to bind HTSP to.";
    };

    ipv6 = lib.mkOption {
      type = lib.types.bool;
      default = config.networking.enableIPv6;
      defaultText = lib.literalExpression "config.networking.enableIPv6";
      description = "Whether to listen on IPv6 as well as IPv4.";
    };

    bindAddr = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "127.0.0.1";
      description = "Bind address for HTTP and HTSP.";
    };

    openFirewall = lib.mkEnableOption "opening Tvheadend TCP ports in the firewall";

    firstRun = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to pass `--firstrun` on startup.

        If no access rules exist, Tvheadend creates a rule granting anonymous
        administrator access. Set {option}`services.tvheadend.bindAddr` to
        `127.0.0.1` during setup. Replace the anonymous rule before exposing
        the service; disabling this option does not remove the rule.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Additional command line arguments passed to tvheadend.";
      example = [
        "--debug"
        "dvr"
      ];
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.httpPort
      cfg.htspPort
    ];

    users.users = lib.mkIf (cfg.user == "tvheadend") {
      tvheadend = {
        description = "Tvheadend service user";
        isSystemUser = true;
        group = cfg.group;
        inherit (cfg) extraGroups;
        home = cfg.dataDir;
        createHome = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "tvheadend") {
      tvheadend = { };
    };

    systemd.tmpfiles.settings.tvheadend = {
      "${cfg.dataDir}"."d" = {
        mode = "0750";
        inherit (cfg) user group;
      };
    };

    systemd.services.tvheadend = {
      description = "Tvheadend TV streaming server";

      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        SupplementaryGroups = lib.mkIf (cfg.user != "tvheadend") cfg.extraGroups;
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
        RestartSec = 5;

        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe cfg.package)
            "--config"
            (toString cfg.dataDir)
            "--http_port"
            (toString cfg.httpPort)
            "--htsp_port"
            (toString cfg.htspPort)
          ]
          ++ lib.optionals (cfg.bindAddr != null) [
            "--bindaddr"
            cfg.bindAddr
          ]
          ++ lib.optionals cfg.ipv6 [ "--ipv6" ]
          ++ lib.optionals cfg.firstRun [ "--firstrun" ]
          ++ cfg.extraArgs
        );
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ juaningan ];
}
