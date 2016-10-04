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

    ca = mkOption {
      default = "https://acme-v01.api.letsencrypt.org/directory";
      example = "https://acme-staging.api.letsencrypt.org/directory";
      type = types.string;
      description = "Certificate authority ACME server. The default (Let's Encrypt production server) should be fine for most people.";
    };

    email = mkOption {
      default = "";
      type = types.string;
      description = "Email address (for Let's Encrypt certificate)";
    };

    agree = mkOption {
      default = false;
      example = true;
      type = types.bool;
      description = "Agree to Let's Encrypt Subscriber Agreement";
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
        ExecStart = ''${pkgs.caddy.bin}/bin/caddy -conf=${configFile} \
          -ca=${cfg.ca} -email=${cfg.email} ${optionalString cfg.agree "-agree"}
        '';
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
