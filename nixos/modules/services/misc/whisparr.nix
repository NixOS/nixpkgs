{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.whisparr;
in
{
  options = {
    services.whisparr = {
      enable = mkEnableOption "Whisparr";

      package = mkOption {
        description = "Whisparr package to use";
        default = pkgs.whisparr;
        defaultText = literalExpression "pkgs.whisparr";
        example = literalExpression "pkgs.whisparr";
        type = types.package;
      };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/whisparr/.config/Whisparr";
        description = "The directory where Whisparr stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the Whisparr web interface.";
      };

      user = mkOption {
        type = types.str;
        default = "whisparr";
        description = "User account under which Whisparr runs.";
      };

      group = mkOption {
        type = types.str;
        default = "whisparr";
        description = "Group under which Whisparr runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [ "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -" ];

    systemd.services.whisparr = {
      description = "Whisparr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${lib.getExe cfg.package} -nobrowser -data='${cfg.dataDir}'";
        Restart = "on-failure";
      };
    };

    networking.firewall = mkIf cfg.openFirewall { allowedTCPPorts = [ 6969 ]; };

    users.users = mkIf (cfg.user == "whisparr") {
      whisparr = {
        group = cfg.group;
        home = cfg.dataDir;
        uid = config.ids.uids.whisparr;
      };
    };

    users.groups = mkIf (cfg.group == "whisparr") { whisparr.gid = config.ids.gids.whisparr; };
  };
}
