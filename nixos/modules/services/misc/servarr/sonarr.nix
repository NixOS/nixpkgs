{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.sonarr;
  servarr = import ./settings-options.nix { inherit lib pkgs; };
in
{
  options = {
    services.sonarr = {
      enable = lib.mkEnableOption "Sonarr";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/sonarr/.config/NzbDrone";
        description = ''
          The Sonarr home directory used to store all data. If left as the default value
          this directory will automatically be created before the Sonarr server starts, otherwise
          you are responsible for ensuring the directory exists with appropriate ownership
          and permissions.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the Sonarr web interface
        '';
      };

      environmentFiles = servarr.mkServarrEnvironmentFiles "sonarr";

      settings = servarr.mkServarrSettingsOptions "sonarr" 8989;

      user = lib.mkOption {
        type = lib.types.str;
        default = "sonarr";
        description = ''
          User account under which Sonarr runs.";

          ::: {.note}
          If left as the default value this user will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the user exists before the Sonarr service starts.
          :::
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "sonarr";
        description = ''
          Group account under which Sonarr runs.

          ::: {.note}
          If left as the default value this group will automatically be created
          on system activation, otherwise you are responsible for
          ensuring the group exists before the Sonarr service starts.
          :::
        '';
      };

      package = lib.mkPackageOption pkgs "sonarr" { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.sonarr = {
      description = "Sonarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = servarr.mkServarrSettingsEnvVars "SONARR" cfg.settings;
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "-nobrowser"
          "-data=${cfg.dataDir}"
        ];
        Restart = "on-failure";
      }
      // lib.optionalAttrs (cfg.dataDir == "/var/lib/sonarr/.config/NzbDrone") {
        StateDirectory = "sonarr";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.server.port ];
    };

    users.users = lib.mkIf (cfg.user == "sonarr") {
      sonarr = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.sonarr;
      };
    };

    users.groups = lib.mkIf (cfg.group == "sonarr") {
      sonarr.gid = config.ids.gids.sonarr;
    };
  };
}
