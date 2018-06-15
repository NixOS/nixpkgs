{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.cfdyndns;
in
{
  options = {
    services.cfdyndns = {
      enable = mkEnableOption "Cloudflare Dynamic DNS Client";

      email = mkOption {
        type = types.str;
        description = ''
          The email address to use to authenticate to CloudFlare.
        '';
      };

      apikey = mkOption {
        type = types.str;
        description = ''
          The API Key to use to authenticate to CloudFlare.
        '';
      };

      records = mkOption {
        default = [];
        example = [ "host.tld" ];
        type = types.listOf types.str;
        description = ''
          The records to update in CloudFlare.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.cfdyndns = {
      description = "CloudFlare Dynamic DNS Client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      startAt = "5 minutes";
      serviceConfig = {
        Type = "simple";
        User = config.ids.uids.cfdyndns;
        Group = config.ids.gids.cfdyndns;
        ExecStart = "/bin/sh -c '${pkgs.cfdyndns}/bin/cfdyndns'";
      };
      environment = {
        CLOUDFLARE_EMAIL="${cfg.email}";
        CLOUDFLARE_APIKEY="${cfg.apikey}";
        CLOUDFLARE_RECORDS="${concatStringsSep "," cfg.records}";
      };
    };

    users.extraUsers = {
      cfdyndns = {
        group = "cfdyndns";
        uid = config.ids.uids.cfdyndns;
      };
    };

    users.extraGroups = {
      cfdyndns = {
        gid = config.ids.gids.cfdyndns;
      };
    };
  };
}
