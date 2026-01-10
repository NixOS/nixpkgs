{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.qui;
  format = pkgs.formats.toml { };
  configFile = format.generate "config.toml" cfg.settings;
in
{
  options = {
    services.qui = {
      enable = lib.mkEnableOption "Qui, A fast, single-binary qBittorrent web UI";

      package = lib.mkPackageOption pkgs "qui" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the qui web interface.";
      };
      sessionSecretPath = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        description = "Path to file containing secret";
        default = null;
      };

      settings =
        with lib;
        mkOption {
          type = types.submodule {
            freeformType = format.type;

            options = {
              host = mkOption {
                type = types.nullOr types.str;
                description = "Address to bind";
                default = "localhost";
              };
              port = mkOption {
                type = types.nullOr types.int;
                description = "Port to bind";
                default = 7476;
              };
              dataDir = mkOption {
                type = types.nullOr types.path;
                description = "The directory where data is stored";
                default = "/var/lib/qui";
              };
            };
          };
          default = { };
          description = "Qui configuration, see <https://getqui.com/docs/intro> for reference.";
        };

      user = lib.mkOption {
        type = lib.types.str;
        default = "qui";
        description = "User account under which qui runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "qui";
        description = "Group under which qui runs.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.qui = {
      description = "qui";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        QUI__SESSION_SECRET_FILE = cfg.sessionSecretPath;
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "qui";
        ExecStart = "${cfg.package}/bin/qui serve --config-dir ${configFile}";
        Restart = "on-failure";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "full";
        ReadWritePaths = [ "/var/lib/qui" ];
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.port ];
    };

    users.users = lib.mkIf (cfg.user == "qui") {
      qui = {
        group = cfg.group;
        home = cfg.settings.dataDir;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "qui") {
      qui = { };
    };
  };
}
