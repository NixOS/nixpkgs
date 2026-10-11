{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.whisparr;
  servarr = import ./settings-options.nix { inherit lib pkgs; };
in
{
  options = {
    services.whisparr = {
      enable = lib.mkEnableOption "Whisparr";

      package = lib.mkPackageOption pkgs "whisparr" { };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/whisparr/.config/Whisparr";
        description = "The directory where Whisparr stores its data files.";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for the Whisparr web interface.";
      };

      settings = servarr.mkServarrSettingsOptions "whisparr" 6969;

      environmentFiles = servarr.mkServarrEnvironmentFiles "whisparr";

      user = lib.mkOption {
        type = lib.types.str;
        default = "whisparr";
        description = "User account under which Whisparr runs.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "whisparr";
        description = "Group under which Whisparr runs.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -" ];

    systemd.services.whisparr = {
      description = "Whisparr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = servarr.mkServarrSettingsEnvVars "WHISPARR" cfg.settings;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = cfg.environmentFiles;
        ExecStart = "${lib.getExe cfg.package} -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.settings.server.port ];
    };

    users.users = lib.mkIf (cfg.user == "whisparr") {
      whisparr = {
        group = cfg.group;
        home = cfg.dataDir;
        isSystemUser = true;
      };
    };

    users.groups.whisparr = lib.mkIf (cfg.group == "whisparr") { };
  };
}
