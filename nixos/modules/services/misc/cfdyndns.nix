{ config, pkgs, lib, ... }:
let
  cfg = config.services.cfdyndns;
in
{
  imports = [
    (lib.mkRemovedOptionModule
      [ "services" "cfdyndns" "apikey" ]
      "Use services.cfdyndns.apikeyFile instead.")
  ];

  options = {
    services.cfdyndns = {
      enable = lib.mkEnableOption "Cloudflare Dynamic DNS Client";

      email = lib.mkOption {
        type = lib.types.str;
        description = ''
          The email address to use to authenticate to CloudFlare.
        '';
      };

      apiTokenFile = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = ''
          The path to a file containing the API Token
          used to authenticate with CloudFlare.
        '';
      };

      apikeyFile = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = ''
          The path to a file containing the API Key
          used to authenticate with CloudFlare.
        '';
      };

      records = lib.mkOption {
        default = [];
        example = [ "host.tld" ];
        type = lib.types.listOf lib.types.str;
        description = ''
          The records to update in CloudFlare.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.cfdyndns = {
      description = "CloudFlare Dynamic DNS Client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      startAt = "*:0/5";
      serviceConfig = {
        Type = "simple";
        LoadCredential = lib.optional (cfg.apiTokenFile != null) "CLOUDFLARE_APITOKEN_FILE:${cfg.apiTokenFile}";
        DynamicUser = true;
      };
      environment = {
        CLOUDFLARE_RECORDS="${lib.concatStringsSep "," cfg.records}";
      };
      script = ''
        ${lib.optionalString (cfg.apikeyFile != null) ''
          export CLOUDFLARE_APIKEY="$(cat ${lib.escapeShellArg cfg.apikeyFile})"
          export CLOUDFLARE_EMAIL="${cfg.email}"
        ''}
        ${lib.optionalString (cfg.apiTokenFile != null) ''
          export CLOUDFLARE_APITOKEN=$(${pkgs.systemd}/bin/systemd-creds cat CLOUDFLARE_APITOKEN_FILE)
        ''}
        ${pkgs.cfdyndns}/bin/cfdyndns
      '';
    };
  };
}
