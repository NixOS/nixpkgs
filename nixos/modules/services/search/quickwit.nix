{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.quickwit;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "quickwit.yaml" cfg.settings;
in
{
  options.services.quickwit = {
    package = mkOption {
      type = types.package;
      description = "Quickwit package to use.";
      default = pkgs.quickwit;
    };

    enable = mkEnableOption "Quickwit search engine";

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = "Environment file to pass to the systemd service.";
    };

    settings = mkOption {
      description = "Quickwit settings.";
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          listen_address = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "Address to listen on.";
          };

          data_dir = mkOption {
            type = types.path;
            default = "/var/lib/quickwit";
            description = "Path to the directory where Quickwit will store its data.";
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
      chown -R quickwit:quickwit ${cfg.settings.data_dir}
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
        User = "quickwit";
        Group = "quickwit";
        ProtectHome = true;
        NoNewPrivileges = true;
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
      };
    };
  };
  meta.maintainers = with maintainers; [ tcheronneau ];
}
