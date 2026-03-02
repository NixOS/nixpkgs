{
  config,
  lib,
  pkgs,
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
      default = false;
      description = "Listen on IPv6.";
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

        This will create an initial admin account with no username and no
        password if no access control exists yet.
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

    users.groups.tvheadend = lib.mkIf (cfg.group == "tvheadend") { };

    users.users.tvheadend = lib.mkIf (cfg.user == "tvheadend") {
      description = "Tvheadend service user";
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
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
        SupplementaryGroups = [ "video" ];
        WorkingDirectory = cfg.dataDir;
        Environment = [ "HOME=${toString cfg.dataDir}" ];
        Restart = "on-failure";
        RestartSec = 5;

        ExecStart = lib.escapeShellArgs (
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
}
