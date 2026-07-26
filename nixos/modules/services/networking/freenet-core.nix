{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.freenet-core;

  command = [
    (lib.getExe cfg.package)
    "network"
    "--disable-auto-update"
    "--config-dir=${cfg.configDir}"
    "--data-dir=${cfg.dataDir}"
    "--log-dir=${cfg.logDir}"
    "--network-address=${cfg.networkAddress}"
    "--network-port=${toString cfg.networkPort}"
    "--ws-api-address=${cfg.websocketAddress}"
    "--ws-api-port=${toString cfg.websocketPort}"
  ]
  ++ cfg.extraArgs;
in
{
  options.services.freenet-core = {
    enable = lib.mkEnableOption "Freenet node";

    package = lib.mkPackageOption pkgs "freenet-core" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "freenet-core";
      example = "freenet";
      description = "User account under which Freenet runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "freenet-core";
      example = "freenet";
      description = "Group under which Freenet runs.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/freenet-core";
      example = "/srv/freenet-core";
      description = "Directory used to store Freenet node data.";
    };

    configDir = lib.mkOption {
      type = lib.types.path;
      default = "${cfg.dataDir}/config";
      defaultText = lib.literalExpression ''"''${config.services.freenet-core.dataDir}/config"'';
      example = "/srv/freenet-core/config";
      description = "Directory used to store Freenet configuration.";
    };

    logDir = lib.mkOption {
      type = lib.types.path;
      default = "${cfg.dataDir}/logs";
      defaultText = lib.literalExpression ''"''${config.services.freenet-core.dataDir}/logs"'';
      example = "/var/log/freenet-core";
      description = "Directory used to store Freenet logs.";
    };

    networkAddress = lib.mkOption {
      type = lib.types.str;
      default = "::";
      example = "0.0.0.0";
      description = "Address on which the Freenet peer-to-peer transport listens.";
    };

    networkPort = lib.mkOption {
      type = lib.types.port;
      default = 31337;
      example = 31338;
      description = "UDP port on which the Freenet peer-to-peer transport listens.";
    };

    websocketAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "::1";
      description = "Address on which the Freenet HTTP and WebSocket API listens.";
    };

    websocketPort = lib.mkOption {
      type = lib.types.port;
      default = 7509;
      example = 7510;
      description = "TCP port on which the Freenet HTTP and WebSocket API listens.";
    };

    nice = lib.mkOption {
      type = lib.types.ints.between (-20) 19;
      default = 10;
      example = 5;
      description = "Nice level for the Freenet process.";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        RUST_LOG = "freenet=debug";
      };
      description = "Environment variables passed to the Freenet process.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--telemetry-enabled"
        "--total-bandwidth-limit=10000000"
      ];
      description = "Additional command-line arguments passed to Freenet.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Whether to open the Freenet peer-to-peer UDP port in the firewall.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ cfg.networkPort ];

    systemd.tmpfiles.settings."10-freenet-core" = {
      ${cfg.dataDir}.d = {
        user = cfg.user;
        group = cfg.group;
        mode = "0700";
      };
      ${cfg.configDir}.d = {
        user = cfg.user;
        group = cfg.group;
        mode = "0700";
      };
      ${cfg.logDir}.d = {
        user = cfg.user;
        group = cfg.group;
        mode = "0700";
      };
    };

    systemd.services.freenet-core = {
      description = "Freenet node";
      documentation = [ "https://freenet.org/" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.environment;
      serviceConfig = {
        ExecStart = lib.escapeShellArgs command;
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        Nice = cfg.nice;
        UMask = "0077";
        Restart = "on-failure";
        RestartSec = 10;
        TimeoutStopSec = 45;
      };
    };

    users.users = lib.mkIf (cfg.user == "freenet-core") {
      freenet-core = {
        isSystemUser = true;
        group = cfg.group;
        description = "Freenet node user";
        home = cfg.dataDir;
        createHome = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "freenet-core") {
      freenet-core = { };
    };
  };

  meta.maintainers = [ lib.maintainers.LisaScheers ];
  meta.doc = ./freenet-core.md;
}
