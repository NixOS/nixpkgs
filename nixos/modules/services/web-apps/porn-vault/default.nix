{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.porn-vault;
  configFormat = pkgs.formats.json { };
  defaultConfig = import ./default-config.nix;
  inherit (lib)
    mkIf
    mkEnableOption
    mkPackageOption
    mkOption
    getExe
    literalExpression
    types
    ;
in
{
  options = {
    services.porn-vault = {
      enable = lib.mkEnableOption "Porn-Vault";

      package = lib.mkPackageOption pkgs "porn-vault" { };

      autoStart = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to start porn-vault automatically.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = ''
          Which port Porn-Vault will use.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to open the Porn-Vault port in the firewall.
        '';
      };

      settings = mkOption {
        type = configFormat.type;
        description = ''
          Configuration for Porn-Vault. The attributes are serialized to JSON in config.json.

          See <https://gitlab.com/porn-vault/porn-vault/-/blob/dev/config.example.json>
        '';
        default = defaultConfig;
        apply = lib.recursiveUpdate defaultConfig;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.porn-vault = {
      description = "Porn-Vault server";
      environment = {
        PV_CONFIG_FOLDER = "/etc/porn-vault";
        NODE_ENV = "production";
        DATABASE_NAME = "production";
        PORT = toString cfg.port;
      };
      serviceConfig = {
        ExecStart = getExe cfg.package;
        CacheDirectory = "porn-vault";
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
        ProtectSystem = true;
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
        Restart = "on-failure";
        RestartSec = 5;
      };
      wantedBy = mkIf cfg.autoStart [ "multi-user.target" ];
      wants = [ "network.target" ];
    };

    environment.etc = {
      "porn-vault/config.json".source = configFormat.generate "config.json" cfg.settings;
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = [ lib.maintainers.luNeder ];
}
