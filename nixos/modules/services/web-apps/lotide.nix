{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.lotide;
in
{
  options.services.lotide = {
    enable = mkEnableOption "the lotide service";

    databaseUrl = mkOption {
      default = null;
      type = types.str;
      description = "Credentials for database connection.";
      example = "postgresql://user:passwort@somehost:5432/databasename";
    };

    hostUrlActivityPub = mkOption {
      default = null;
      type = types.str;
      description = "If using the recommended proxy setup, set this to your root address.";
      example = "https://example.com";
    };

    hostUrlAPI = mkOption {
      default = null;
      type = types.str;
      description = "URL for API.";

      example = "https://example.com/api";
    };

    apubProxyRewrites = mkOption {
      default = false;
      type = types.bool;
      description = "Set to <literal>true</literal> to make signatures work with the proxy setup.";
    };

    allowForwarded = mkOption {
      default = false;
      type = types.bool;
      description = "Set to <literal>true</literal> to make ratelimiting work with the proxy setup.";
    };

    smtpUrl = mkOption {
      default = null;
      type = with types; nullOr str;
      description = "URL used to access SMTP server, required for sending email.";

      example = "smtps://username:password@smtp.example.com";
    };

    smtpFrom = mkOption {
      default = null;
      type = with types; nullOr str;
      description = "From value used in sent emails, required for sending email.";
    };

    mediaLocation = mkOption {
      default = null;
      type = with types; nullOr str;
      description = ''
        Directory on disk used for storing uploaded images. If not set, image uploads will be disabled.
        Must be created before this service is started.
      '';

      example = "/var/lotide/imgs";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.lotide = {
      description = "lotide Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      environment = lib.mkMerge [
        {
          ALLOW_FORWARDED = boolToString cfg.allowForwarded;
          APUB_PROXY_REWRITES = boolToString cfg.apubProxyRewrites;
          DATABASE_URL = cfg.databaseUrl;
          HOST_URL_ACTIVITYPUB = cfg.hostUrlActivityPub;
          HOST_URL_API = cfg.hostUrlAPI;
        }
        (mkIf (cfg.mediaLocation != null) { MEDIA_LOCATION = cfg.mediaLocation; })
        (mkIf (cfg.smtpUrl != null) { SMTP_URL = cfg.smtpUrl; })
        (mkIf (cfg.smtpFrom != null) { SMTP_FROM = cfg.smtpFrom; })
      ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.lotide}/bin/lotide";
        PrivateTmp = true;
        Restart = "always";
        StateDirectory = "lotide";
        WorkingDirectory = "%S/lotide";
      };
    };
  };
}

