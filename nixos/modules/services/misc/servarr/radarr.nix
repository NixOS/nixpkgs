{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.radarr;
  servarr = import ./settings-options.nix { inherit lib pkgs; };
in
{
  options = {
    services.radarr = {
      enable = lib.mkEnableOption "Radarr, a UsetNet/BitTorrent movie downloader";

      package = lib.mkPackageOption pkgs "radarr" { };

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/radarr/.config/Radarr";
        description = "The directory where Radarr stores its data files.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the Radarr web interface.";
      };

      settings = servarr.mkServarrSettingsOptions "radarr" 7878;

      environmentFiles = servarr.mkServarrEnvironmentFiles "radarr";

      user = lib.mkOption {
        type = lib.types.str;
        default = "radarr";
        description = "User account under which Radarr runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "radarr";
        description = "Group under which Radarr runs.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings."10-radarr".${cfg.dataDir}.d = {
      inherit (cfg) user group;
      mode = "0700";
    };

    systemd.services.radarr = {
      description = "Radarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = servarr.mkServarrSettingsEnvVars "RADARR" cfg.settings;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = "${cfg.package}/bin/Radarr -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.server.port ];
    };

    users.users = lib.mkIf (cfg.user == "radarr") {
      radarr = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.radarr;
      };
    };

    users.groups = lib.mkIf (cfg.group == "radarr") {
      radarr.gid = config.ids.gids.radarr;
    };
  };
}
