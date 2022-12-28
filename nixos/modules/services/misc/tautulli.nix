{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.tautulli;
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "plexpy" ] [ "services" "tautulli" ])
  ];

  options = {
    services.tautulli = {
      enable = mkEnableOption (lib.mdDoc "Tautulli Plex Monitor");

      dataDir = mkOption {
        type = types.str;
        default = "/var/lib/plexpy";
        description = lib.mdDoc "The directory where Tautulli stores its data files.";
      };

      configFile = mkOption {
        type = types.str;
        default = "/var/lib/plexpy/config.ini";
        description = lib.mdDoc "The location of Tautulli's config file.";
      };

      port = mkOption {
        type = types.port;
        default = 8181;
        description = lib.mdDoc "TCP port where Tautulli listens.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for Tautulli.";
      };

      user = mkOption {
        type = types.str;
        default = "plexpy";
        description = lib.mdDoc "User account under which Tautulli runs.";
      };

      group = mkOption {
        type = types.str;
        default = "nogroup";
        description = lib.mdDoc "Group under which Tautulli runs.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.tautulli;
        defaultText = literalExpression "pkgs.tautulli";
        description = lib.mdDoc ''
          The Tautulli package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' - ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.tautulli = {
      description = "Tautulli Plex Monitor";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        GuessMainPID = "false";
        ExecStart = "${cfg.package}/bin/tautulli --datadir ${cfg.dataDir} --config ${cfg.configFile} --port ${toString cfg.port} --pidfile ${cfg.dataDir}/tautulli.pid --nolaunch";
        Restart = "on-failure";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

    users.users = mkIf (cfg.user == "plexpy") {
      plexpy = { group = cfg.group; uid = config.ids.uids.plexpy; };
    };
  };
}
