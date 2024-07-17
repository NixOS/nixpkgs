{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.oink;
  makeOinkConfig =
    attrs:
    (pkgs.formats.json { }).generate "oink.json" (mapAttrs' (k: v: nameValuePair (toLower k) v) attrs);
  oinkConfig = makeOinkConfig {
    global = cfg.settings;
    domains = cfg.domains;
  };
in
{
  options.services.oink = {
    enable = mkEnableOption "Oink, a dynamic DNS client for Porkbun";
    package = mkPackageOption pkgs "oink" { };
    settings = {
      apiKey = mkOption {
        type = types.str;
        description = "API key to use when modifying DNS records.";
      };
      secretApiKey = mkOption {
        type = types.str;
        description = "Secret API key to use when modifying DNS records.";
      };
      interval = mkOption {
        # https://github.com/rlado/oink/blob/v1.1.1/src/main.go#L364
        type = types.ints.between 60 172800; # 48 hours
        default = 900;
        description = "Seconds to wait before sending another request.";
      };
      ttl = mkOption {
        type = types.ints.between 600 172800;
        default = 600;
        description = ''
          The TTL ("Time to Live") value to set for your DNS records.

          The TTL controls how long in seconds your records will be cached
          for. A smaller value will allow the record to update quicker.
        '';
      };
    };
    domains = mkOption {
      type = with types; listOf (attrsOf anything);
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

  config = mkIf cfg.enable {
    systemd.services.oink = {
      description = "Dynamic DNS client for Porkbun";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = "${cfg.package}/bin/oink -c ${oinkConfig}";
    };
  };
}
