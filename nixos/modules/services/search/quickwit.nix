{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.quickwit;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "quickwit.yaml" cfg.settings;
in
{
  options.services.quickwit = {
    package = mkPackageOptionMD pkgs "quickwit" { };

    enable = mkEnableOption "Quickwit search engine";

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Environment file to pass to the systemd service.";
    };

    settings = mkOption {
      description = "Quickwit node configuration, see <https://quickwit.io/docs/configuration/node-config>";
      default = { };
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {

          version = mkOption {
            type = types.str;
            default = "0.7";
            description = "Config file version.";
          };

          listen_address = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "The IP address or hostname that Quickwit service binds to for starting REST and GRPC server and connecting this node to other nodes.";
          };

          rest = {
            listen_port = mkOption {
              type = types.port;
              default = 7280;
              description = "The port on which the REST API listens for HTTP traffic.";
            };
          };

          data_dir = mkOption {
            type = types.path;
            default = "/var/lib/quickwit";
            description = "Path to directory where data (tmp data, splits kept for caching purpose) is persisted. This is mostly used in indexing.";
          };

        };
      };
    };
  };
  config = mkIf cfg.enable {
    users.users.quickwit = {
      description = "Quickwit daemon user";
      isSystemUser = true;
      group = "quickwit";
    };
    users.groups.quickwit = {};
    system.activationScripts.makeQuickwitDir = ''
      mkdir -p ${cfg.settings.data_dir}
      chown -R ${config.users.users.quickwit.name}:${config.users.users.quickwit.group} ${cfg.settings.data_dir}
    '';
    systemd.services.quickwit = {
      description = "Quickwit search engine";
      after = [ "network.target" "network-online.target" ];
      wants = [ "network.target" "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configFile ] ++ (lib.optional (cfg.environmentFile != null) cfg.environmentFile);
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/quickwit run --config ${configFile}";
        StateDirectory = cfg.settings.data_dir;
        User = "${config.users.users.quickwit.name}";
        Group = "${config.users.users.quickwit.group}";
        ProtectHome = true;
        NoNewPrivileges = true;
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
      };
    };
  };
  meta.maintainers = with maintainers; [ tcheronneau nh2 ];
}
