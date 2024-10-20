{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types mkIf;

  cfg = config.services.shokoserver;
in
{
  options = {
    services.shokoserver = {
      enable = lib.mkEnableOption "ShokoServer";

      package = lib.mkPackageOption pkgs "shokoserver" { };
      webui = lib.mkPackageOption pkgs "shoko-webui" { nullable = true; };

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/shoko";
        description = "The directory where ShokoServer stores its data files.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the ShokoAnime api and web interface.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "shoko";
        description = "User account under which ShokoServer runs.";
      };

      group = mkOption {
        type = types.str;
        default = "shoko";
        description = "Group under which ShokoServer runs.";
      };
    };
  };

  config = mkIf cfg.enable {
    users = {
      users.shoko = mkIf (cfg.user == "shoko") {
        inherit (cfg) group;
        home = cfg.dataDir;
        uid = config.ids.uids.shoko;
        createHome = true;
      };

      groups.shoko.gid = mkIf (cfg.group == "shoko") config.ids.gids.shoko;
    };

    systemd.services.shokoserver = {
      description = "ShokoServer";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment.SHOKO_HOME = cfg.dataDir;

      preStart = mkIf (cfg.webui != null) ''
        rm -rf ${cfg.dataDir}/webui
        ln -s ${cfg.webui} ${cfg.dataDir}/webui
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = lib.getExe pkgs.shokoserver;
        Restart = "on-failure";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 8111 ];
  };

  meta.maintainers = [ lib.maintainers.diniamo ];
}
