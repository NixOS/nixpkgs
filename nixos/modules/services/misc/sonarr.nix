{
  config,
  pkgs,
  lib,
  utils,
  ...
}:
let
  cfg = config.services.sonarr;
in
{
  options = {
    services.sonarr = {
      enable = lib.mkEnableOption "Sonarr";

      dataDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/sonarr/.config/NzbDrone";
        description = "The directory where Sonarr stores its data files.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the Sonarr web interface
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "sonarr";
        description = "User account under which Sonaar runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "sonarr";
        description = "Group under which Sonaar runs.";
      };

      package = lib.mkPackageOption pkgs "sonarr" { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.sonarr = {
      description = "Sonarr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "-nobrowser"
          "-data=${cfg.dataDir}"
        ];
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8989 ];
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
