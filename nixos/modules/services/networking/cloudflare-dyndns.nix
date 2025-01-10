{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.cloudflare-dyndns;
in
{
  options = {
    services.cloudflare-dyndns = {
      enable = mkEnableOption "Cloudflare Dynamic DNS Client";

      package = mkPackageOption pkgs "cloudflare-dyndns" { };

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
        description = ''
          List of domain names to update records for.
        '';
      };

      frequency = mkOption {
        type = types.nullOr types.str;
        default = "*:0/5";
        description = ''
          Run cloudflare-dyndns with the given frequency (see
          {manpage}`systemd.time(7)` for the format).
          If null, do not run automatically.
        '';
      };

      proxied = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether this is a DNS-only record, or also being proxied through CloudFlare.
        '';
      };

      ipv4 = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable setting IPv4 A records.
        '';
      };

      ipv6 = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable setting IPv6 AAAA records.
        '';
      };

      deleteMissing = mkOption {
        type = types.bool;
        default = false;
        description = ''
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
          "${getExe cfg.package} ${toString args}";
      };
    } // optionalAttrs (cfg.frequency != null) {
      startAt = cfg.frequency;
    };
  };
}
