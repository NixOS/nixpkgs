{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.duckdns;
  duckdns = pkgs.writeShellScriptBin "duckdns" ''
    DRESPONSE=$(curl -sS --max-time 60 --no-progress-meter -k -K- <<< "url = \"https://www.duckdns.org/update?verbose=true&domains=$DUCKDNS_DOMAINS&token=$DUCKDNS_TOKEN&ip=\"")
    IPV4=$(echo "$DRESPONSE" | awk 'NR==2')
    IPV6=$(echo "$DRESPONSE" | awk 'NR==3')
    RESPONSE=$(echo "$DRESPONSE" | awk 'NR==1')
    IPCHANGE=$(echo "$DRESPONSE" | awk 'NR==4')

    if [[ "$RESPONSE" = "OK" ]] && [[ "$IPCHANGE" = "UPDATED" ]]; then
        if [[ "$IPV4" != "" ]] && [[ "$IPV6" == "" ]]; then
            echo "Your IP was updated at $(date) to IPv4: $IPV4"
        elif [[ "$IPV4" == "" ]] && [[ "$IPV6" != "" ]]; then
            echo "Your IP was updated at $(date) to IPv6: $IPV6"
        else
            echo "Your IP was updated at $(date) to IPv4: $IPV4 & IPv6 to: $IPV6"
        fi
    elif [[ "$RESPONSE" = "OK" ]] && [[ "$IPCHANGE" = "NOCHANGE" ]]; then
        echo "DuckDNS request at $(date) successful. IP(s) unchanged."
    else
        echo -e "Something went wrong, please check your settings\nThe response returned was:\n$DRESPONSE\n"
        exit 1
    fi
  '';
in
{
  options.services.duckdns = {
    enable = lib.mkEnableOption "DuckDNS Dynamic DNS Client";
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
        The domain(s) to update in DuckDNS
        (without the .duckdns.org suffix)
      '';
    };

    domainsFile = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.path;
      example = lib.literalExpression ''
        pkgs.writeText "duckdns-domains.txt" '''
          examplehost
          examplehost2
          examplehost3
        '''
      '';
      description = ''
        The path to a file containing a
        newline-separated list of DuckDNS
        domain(s) to be updated
        (without the .duckdns.org suffix)
      '';
    };

  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.domains != null || cfg.domainsFile != null;
        message = "Either services.duckdns.domains or services.duckdns.domainsFile has to be defined";
      }
      {
        assertion = !(cfg.domains != null && cfg.domainsFile != null);
        message = "services.duckdns.domains and services.duckdns.domainsFile can't both be defined at the same time";
      }
      {
        assertion = (cfg.tokenFile != null);
        message = "services.duckdns.tokenFile has to be defined";
      }
    ];

    environment.systemPackages = [ duckdns ];

    systemd.services.duckdns = {
      description = "DuckDNS Dynamic DNS Client";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      startAt = "*:0/5";
      path = [
        pkgs.gnused
        pkgs.systemd
        pkgs.curl
        pkgs.gawk
        duckdns
      ];
      serviceConfig = {
        Type = "simple";
        LoadCredential = [
          "DUCKDNS_TOKEN_FILE:${cfg.tokenFile}"
        ] ++ lib.optionals (cfg.domainsFile != null) [ "DUCKDNS_DOMAINS_FILE:${cfg.domainsFile}" ];
        DynamicUser = true;
      };
      script = ''
        export DUCKDNS_TOKEN=$(systemd-creds cat DUCKDNS_TOKEN_FILE)
        ${lib.optionalString (cfg.domains != null) ''
          export DUCKDNS_DOMAINS='${lib.strings.concatStringsSep "," cfg.domains}'
        ''}
        ${lib.optionalString (cfg.domainsFile != null) ''
          export DUCKDNS_DOMAINS=$(systemd-creds cat DUCKDNS_DOMAINS_FILE | sed -z 's/\n/,/g')
        ''}
        exec ${lib.getExe duckdns}
      '';
    };
  };

  meta.maintainers = with lib.maintainers; [ notthebee ];
}
