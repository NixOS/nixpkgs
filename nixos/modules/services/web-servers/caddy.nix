{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.caddy;
  configFile = pkgs.writeText "Caddyfile" cfg.config;
in
{
  options.services.caddy = {
    enable = mkEnableOption "Caddy web server";

    config = mkOption {
      description = "Verbatim Caddyfile to use";
    };

    email = mkOption {
      default = "";
      type = types.string;
      description = "Email address (for Let's Encrypt certificate)";
    };

    dataDir = mkOption {
      default = "/var/lib/caddy";
      type = types.path;
      description = "The data directory, for storing certificates.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.caddy = {
      description = "Caddy web server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.caddy}/bin/caddy -conf=${configFile} -email=${cfg.email}";
	Type = "simple";
	User = "caddy";
	Group = "caddy";
	AmbientCapabilities = "cap_net_bind_service";
      };
    };

    users.extraUsers.caddy = {
      group = "caddy";
      uid = config.ids.uids.caddy;
      home = cfg.dataDir;
      createHome = true;
    };

    users.extraGroups.caddy.gid = config.ids.uids.caddy;
  };
}
