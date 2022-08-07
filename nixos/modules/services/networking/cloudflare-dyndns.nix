{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.cloudflare-dyndns;
in
{
  options = {
    services.cloudflare-dyndns = {
      enable = mkEnableOption "Cloudflare Dynamic DNS Client";

      apiTokenFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The path to a file containing the CloudFlare API token.

          The file must have the form `CLOUDFLARE_API_TOKEN=...`
        '';
      };

      domains = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = lib.mdDoc ''
          List of domain names to update records for.
        '';
      };

      proxied = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether this is a DNS-only record, or also being proxied through CloudFlare.
        '';
      };

      ipv4 = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to enable setting IPv4 A records.
        '';
      };

      ipv6 = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable setting IPv6 AAAA records.
        '';
      };

      deleteMissing = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to delete the record when no IP address is found.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.cloudflare-dyndns = {
      description = "CloudFlare Dynamic DNS Client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      startAt = "*:0/5";

      environment = {
        CLOUDFLARE_DOMAINS = toString cfg.domains;
      };

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "cloudflare-dyndns";
        EnvironmentFile = cfg.apiTokenFile;
        ExecStart =
          let
            args = [ "--cache-file /var/lib/cloudflare-dyndns/ip.cache" ]
              ++ (if cfg.ipv4 then [ "-4" ] else [ "-no-4" ])
              ++ (if cfg.ipv6 then [ "-6" ] else [ "-no-6" ])
              ++ optional cfg.deleteMissing "--delete-missing"
              ++ optional cfg.proxied "--proxied";
          in
          "${pkgs.cloudflare-dyndns}/bin/cloudflare-dyndns ${toString args}";
      };
    };
  };
}
