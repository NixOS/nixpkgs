{ pkgs, lib, config, options, ... }:

with lib;

let
  cfg = config.services.godns;

  cfgFile = pkgs.writeText "godns.json" (builtins.toJSON (
    (filterAttrsRecursive (n: v: v != null && v != []) ({
      provider = cfg.provider;
      email = cfg.email;
      password = cfg.password;
      password_file = cfg.passwordFile;
      login_token = cfg.loginToken;
      login_token_file = cfg.loginTokenFile;
      domains = (map
        (elem: {
          domain_name = elem.domainName;
          sub_domains = elem.subDomains;
        })
        cfg.domains);
      ip_url = cfg.ipv4Url;
      ipv6_url = cfg.ipv6Url;
      ip_type = cfg.ipType;
      interval = cfg.interval;
      resolver = cfg.resolver;
    } // cfg.extraConf)
  )));

in
{
  options = {
    services.godns = {
      enable = mkEnableOption "GoDNS";

      package = mkOption {
        type = types.package;
        default = pkgs.godns;
        defaultText = literalExpression "pkgs.godns";
        description = "GoDNS package to use";
      };

      provider = mkOption {
        type = types.enum [ "Cloudflare" "DNSPod" "Dreamhost" "Dynv6" "Google" "AliDNS" "DuckDNS" "NoIP" "HE" "Scaleway" "Linode" ];
        default = "Cloudflare";
        description = "One of the supported DNS providers.";
      };

      email = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Email of the DNS provider.";
      };

      password = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Password of the DNS provider.";
      };

      passwordFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Path to file containing password of the DNS provider.";
      };

      loginToken = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "API token of the DNS provider.";
      };

      loginTokenFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Path to file containing API token of the DNS provider.";
      };

      domains = mkOption {
        type = with types; listOf (submodule { options = {
          domainName = mkOption {
            type = str;
            description = "Name of the domain to update.";
          };
          subDomains = mkOption {
            type = listOf str;
            description = "List of subdomains to update.";
          };
        }; });
        default = [];
        description = "Domains list, with your sub domains.";
      };

      ipv4Url = mkOption {
        type = types.str;
        default = "https://ip4.seeip.org";
        description = "A URL for fetching one's public IPv4 address.";
      };

      ipv6Url = mkOption {
        type = types.str;
        default = "https://ip6.seeip.org";
        description = "A URL for fetching one's public IPv6 address.";
      };

      ipType = mkOption {
        type = types.enum [ "IPv4" "IPv6" ];
        default = "IPv4";
        description = "Switch deciding if IPv4 or IPv6 should be used.";
      };

      interval = mkOption {
        type = types.int;
        default = 300;
        description = "How often (in seconds) the public IP should be updated.";
      };

      resolver = mkOption {
        type = types.str;
        default = "8.8.8.8";
        description = "Address of a public DNS server to use.";
      };

      extraConf = mkOption {
        type = types.attrs;
        default = {};
        description = "GoDNS extra configuration";
      };

      user = mkOption {
        type = types.str;
        default = "godns";
        description = "User under which godns runs.";
      };

      group = mkOption {
        type = types.str;
        default = "godns";
        description = "Group under which godns runs.";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/godns";
        description = "GoDNS data directory.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.godns = {
      description = "GoDNS";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = mkForce {
        WorkingDirectory = cfg.dataDir;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/godns -c ${cfgFile}";
        Restart = "on-failure";
      };
    };

    users.users = mkIf (cfg.user == "godns") {
      godns = {
        description = "GoDNS service user";
        group = cfg.group;
        home = cfg.dataDir;
        isSystemUser = true;
      };
    };

    users.groups = mkIf (cfg.group == "godns") {
      godns = {};
    };
  };
}
