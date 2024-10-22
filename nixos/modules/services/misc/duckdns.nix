{ config, pkgs, lib, ... }:
let
cfg = config.services.duckdns;
in
{
  options.services.duckdns = {
    enable = lib.mkEnableOption ("DuckDNS Dynamic DNS Client");

    tokenFile = lib.mkOption {
      default = null;
      type = lib.types.path;
      description = ''
        The path to a file containing the token
        used to authenticate with DuckDNS.
        '';
    };

    domains = lib.mkOption {
      default = null;
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      example = [ "examplehost" ];
      description = ''
        The record(s) to update in DuckDNS
        (without the .duckdns.org prefix)
        '';
    };

    domainsFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      description = ''
        The path to a file containing a
        newline-separated list of DuckDNS
        domain(s) to be updated
        '';
    };

  };

  config = lib.mkIf cfg.enable {
    assertions = [
    {
      assertion = (cfg.domains != null || cfg.domainsFile != null);
      message = "services.duckdns.domains or services.duckdns.domainsFile has to be defined";
    }
    ];
    systemd.services.duckdns = {
      description = "DuckDNS Dynamic DNS Client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      startAt = "*:0/5";
      serviceConfig = {
        Type = "simple";
        LoadCredential = [
          "DUCKDNS_TOKEN_FILE:${cfg.tokenFile}"
        ] ++ lib.optionals (cfg.domainsFile != null) [ "DUCKDNS_DOMAINS_FILE:${cfg.domainsFile}" ];
        DynamicUser = true;
      };
      script = ''
        export DUCKDNS_TOKEN=$(${pkgs.systemd}/bin/systemd-creds cat DUCKDNS_TOKEN_FILE)
        ${lib.optionalString (cfg.domains != null) ''
          export DUCKDNS_DOMAINS='${lib.strings.concatStringsSep "," cfg.domains}'
            ''}
      ${lib.optionalString (cfg.domainsFile != null) ''
        export DUCKDNS_DOMAINS=$(${pkgs.systemd}/bin/systemd-creds cat DUCKDNS_DOMAINS_FILE | ${pkgs.gnused}/bin/sed -z 's/\n/,/g')
          ''}
      ${pkgs.curl}/bin/curl --no-progress-meter -k "https://www.duckdns.org/update?domains=$DUCKDNS_DOMAINS&token=$DUCKDNS_TOKEN&ip=" | grep -v "KO"
        '';
    };
  };

  meta.maintainers = with lib.maintainers; [ notthebee ];
}
