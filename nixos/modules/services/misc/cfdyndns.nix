{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.cfdyndns;
in
{
  imports = [
    (mkRemovedOptionModule
      [ "services" "cfdyndns" "apikey" ]
      "Use services.cfdyndns.apikeyFile instead.")
  ];

  options = {
    services.cfdyndns = {
      enable = mkEnableOption (lib.mdDoc "Cloudflare Dynamic DNS Client");

      email = mkOption {
        type = types.str;
        description = lib.mdDoc ''
          The email address to use to authenticate to CloudFlare.
        '';
      };

      apiTokenFile = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          The path to a file containing the API Token
          used to authenticate with CloudFlare.
        '';
      };

      apikeyFile = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = lib.mdDoc ''
          The path to a file containing the API Key
          used to authenticate with CloudFlare.
        '';
      };

      records = mkOption {
        default = [];
        example = [ "host.tld" ];
        type = types.listOf types.str;
        description = lib.mdDoc ''
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
      startAt = "*:0/5";
      serviceConfig = {
        Type = "simple";
        LoadCredential = lib.optional (cfg.apiTokenFile != null) "CLOUDFLARE_APITOKEN_FILE:${cfg.apiTokenFile}";
        DynamicUser = true;
      };
      environment = {
        CLOUDFLARE_RECORDS="${concatStringsSep "," cfg.records}";
      };
      script = ''
        ${optionalString (cfg.apikeyFile != null) ''
          export CLOUDFLARE_APIKEY="$(cat ${escapeShellArg cfg.apikeyFile})"
          export CLOUDFLARE_EMAIL="${cfg.email}"
        ''}
        ${optionalString (cfg.apiTokenFile != null) ''
          export CLOUDFLARE_APITOKEN=$(${pkgs.systemd}/bin/systemd-creds cat CLOUDFLARE_APITOKEN_FILE)
        ''}
        ${pkgs.cfdyndns}/bin/cfdyndns
      '';
    };
  };
}
