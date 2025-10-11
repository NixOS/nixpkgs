{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.cook-cli;
  inherit (lib)
    mkIf
    mkEnableOption
    mkPackageOption
    mkOption
    getExe
    types
    ;
in
{
  options = {
    services.cook-cli = {
      enable = lib.mkEnableOption "cook-cli";

      package = lib.mkPackageOption pkgs "cook-cli" { };

      autoStart = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to start cook-cli server automatically.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 9080;
        description = ''
          Which port cook-cli server will use.
        '';
      };

      basePath = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/cook-cli";
        description = ''
          Path to the directory cook-cli will look for recipes.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open the cook-cli server port in the firewall.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.tmpfiles.rules = [
      "d ${cfg.basePath} 0770 cook-cli users"
    ];

    users.users.cook-cli = {
      home = "${cfg.basePath}";
      group = "cook-cli";
      isSystemUser = true;
    };
    users.groups.cook-cli.members = [
      "cook-cli"
    ];

    systemd.services.cook-cli = {
      description = "cook-cli server";
      serviceConfig = {
        ExecStart = "${getExe cfg.package} server --host --port ${toString cfg.port} ${cfg.basePath}";
        WorkingDirectory = cfg.basePath;
        User = "cook-cli";
        Group = "cook-cli";
        # Hardening options
        CapabilityBoundingSet = [ "CAP_SYS_NICE" ];
        AmbientCapabilities = [ "CAP_SYS_NICE" ];
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        ReadWritePaths = cfg.basePath;
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        Restart = "on-failure";
        RestartSec = 5;
      };
      wantedBy = mkIf cfg.autoStart [ "multi-user.target" ];
      wants = [ "network.target" ];
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = [
    lib.maintainers.luNeder
    lib.maintainers.emilioziniades
  ];
}
