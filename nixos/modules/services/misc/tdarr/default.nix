{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tdarr;
in
{
  imports = [
    ./server.nix
    ./node.nix
  ];

  options.services.tdarr = {
    enable = lib.mkEnableOption "Tdarr distributed transcoding system" // {
      description = ''
        Whether to enable Tdarr. This is a convenience option that enables both
        the server and all configured nodes. For more granular control, use
        {option}`services.tdarr.server.enable` and configure nodes individually.
      '';
    };

    package = lib.mkPackageOption pkgs "tdarr" { };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/tdarr";
      description = "Base directory for Tdarr data.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "tdarr";
      description = "User account under which Tdarr runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "tdarr";
      description = "Group under which Tdarr runs.";
    };
  };

  config = lib.mkIf (cfg.enable || cfg.server.enable || cfg.nodes != { }) {
    users.users.tdarr = lib.mkIf (cfg.user == "tdarr") {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
    };
    users.groups.tdarr = lib.mkIf (cfg.group == "tdarr") { };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} -"
    ];
  };

  meta = {
    maintainers = with lib.maintainers; [ mistyttm ];
    doc = ./tdarr.md;
  };
}
