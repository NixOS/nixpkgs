{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.cloudflare-dyndns;
in
{
  options = {
    services.cloudflare-dyndns = {
      enable = lib.mkEnableOption "Cloudflare Dynamic DNS Client";

      package = lib.mkPackageOption pkgs "cloudflare-dyndns" { };

      apiTokenFile = lib.mkOption {
        type = lib.types.externalPath;
        description = ''
          The path to a file containing the CloudFlare API token.
        '';
      };

      domains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          List of domain names to update records for.
        '';
      };

      frequency = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "*:0/5";
        description = ''
          Run cloudflare-dyndns with the given frequency (see
          {manpage}`systemd.time(7)` for the format).
          If null, do not run automatically.
        '';
      };

      proxied = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether this is a DNS-only record, or also being proxied through CloudFlare.
        '';
      };

      ipv4 = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to enable setting IPv4 A records.
        '';
      };

      ipv6 = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable setting IPv6 AAAA records.
        '';
      };

      deleteMissing = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to delete the record when no IP address is found.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
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
        Environment = [ "XDG_CACHE_HOME=%S/cloudflare-dyndns/.cache" ];
        LoadCredential = [
          "apiToken:${cfg.apiTokenFile}"
        ];
      };

      script =
        let
          args = [
            "--cache-file /var/lib/cloudflare-dyndns/ip.cache"
          ]
          ++ (if cfg.ipv4 then [ "-4" ] else [ "-no-4" ])
          ++ (if cfg.ipv6 then [ "-6" ] else [ "-no-6" ])
          ++ lib.optional cfg.deleteMissing "--delete-missing"
          ++ lib.optional cfg.proxied "--proxied";
        in
        ''
          export CLOUDFLARE_API_TOKEN_FILE=''${CREDENTIALS_DIRECTORY}/apiToken

          # Added 2025-03-10: `cfg.apiTokenFile` used to be passed as an
          # `EnvironmentFile` to the service, which required it to be of
          # the form "CLOUDFLARE_API_TOKEN=" rather than just the secret.
          # If we detect this legacy usage, error out.
          token=$(< "''${CLOUDFLARE_API_TOKEN_FILE}")
          if [[ $token == CLOUDFLARE_API_TOKEN* ]]; then
            echo "Error: your api token starts with 'CLOUDFLARE_API_TOKEN='. Remove that, and instead specify just the token." >&2
            exit 1
          fi

          exec ${lib.getExe cfg.package} ${toString args}
        '';
    }
    // lib.optionalAttrs (cfg.frequency != null) {
      startAt = cfg.frequency;
    };
  };
}
