{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.oink;
  makeOinkConfig =
    attrs:
    (pkgs.formats.json { }).generate "oink.json" (
      lib.mapAttrs' (k: v: lib.nameValuePair (lib.toLower k) v) attrs
    );
  oinkConfig = makeOinkConfig {
    global = removeAttrs cfg.settings [
      "apiKey"
      "secretApiKey"
    ];
    domains = cfg.domains;
  };
in
{
  options.services.oink = {
    enable = lib.mkEnableOption "Oink, a dynamic DNS client for Porkbun";
    package = lib.mkPackageOption pkgs "oink" { };
    apiKeyFile = lib.mkOption {
      type = lib.types.path;
      example = "/run/keys/oink-api-key";
      description = "Path to a file containing the API key to use when modifying DNS records.";
    };
    secretApiKeyFile = lib.mkOption {
      type = lib.types.path;
      example = "/run/keys/oink-secret-api-key";
      description = "Path to a file containing the secret API key to use when modifying DNS records.";
    };
    settings = {
      interval = lib.mkOption {
        # https://github.com/rlado/oink/blob/v1.1.1/src/main.go#L364
        type = lib.types.ints.between 60 172800; # 48 hours
        default = 900;
        description = "Seconds to wait before sending another request.";
      };
      ttl = lib.mkOption {
        type = lib.types.ints.between 600 172800;
        default = 600;
        description = ''
          The TTL ("Time to Live") value to set for your DNS records.

          The TTL controls how long in seconds your records will be cached
          for. A smaller value will allow the record to update quicker.
        '';
      };
    };
    domains = lib.mkOption {
      type = with lib.types; listOf (attrsOf anything);
      default = [ ];
      example = [
        {
          domain = "nixos.org";
          subdomain = "";
          ttl = 1200;
        }
        {
          domain = "nixos.org";
          subdomain = "hydra";
        }
      ];
      description = ''
        List of attribute sets containing configuration for each domain.

        Each attribute set must have two attributes, one named *domain*
        and another named *subdomain*. The domain attribute must specify
        the root domain that you want to configure, and the subdomain
        attribute must specify its subdomain if any. If you want to
        configure the root domain rather than a subdomain, leave the
        subdomain attribute as an empty string.

        Additionally, you can use attributes from *services.oink.settings*
        to override settings per-domain.

        Every domain listed here *must* have API access enabled in
        Porkbun's control panel.
      '';
    };
  };

  imports = [
    (lib.mkRemovedOptionModule [ "services" "oink" "settings" "apiKey" ] ''
      This option has been removed because it would make the API key world-readable.
      Use {option}`apiKeyFile` instead.
      If you insist on keeping the API key world-readable, you can use `oink.apiKeyFile = pkgs.writeText "api-key" "secret";`.
    '')
    (lib.mkRemovedOptionModule [ "services" "oink" "settings" "secretApiKey" ] ''
      This option has been removed because it would make the API key world-readable.
      Use {option}`secretApiKeyFile` instead.
      If you insist on keeping the API key world-readable, you can use `oink.secretApiKeyFile = pkgs.writeText "secret-api-key" "secret";`.
    '')
  ];
  config = lib.mkIf cfg.enable {
    systemd.services.oink = {
      description = "Dynamic DNS client for Porkbun";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script =
        lib.optionalString (cfg.apiKeyFile != null) "OINK_OVERRIDE_APIKEY=\"$(cat ${cfg.apiKeyFile})\" "
        + lib.optionalString (
          cfg.secretApiKeyFile != null
        ) "OINK_OVERRIDE_SECRETAPIKEY=\"$(cat ${cfg.secretApiKeyFile})\" "
        + "${cfg.package}/bin/oink -c ${oinkConfig}";
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "10";
      };
    };
  };
}
