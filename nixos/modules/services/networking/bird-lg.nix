{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.bird-lg;
in
{
  options = {
    services.bird-lg = {
      package = mkOption {
        type = types.package;
        default = pkgs.bird-lg;
        defaultText = literalExpression "pkgs.bird-lg";
        description = lib.mdDoc "The Bird Looking Glass package to use.";
      };

      user = mkOption {
        type = types.str;
        default = "bird-lg";
        description = lib.mdDoc "User to run the service.";
      };

      group = mkOption {
        type = types.str;
        default = "bird-lg";
        description = lib.mdDoc "Group to run the service.";
      };

      frontend = {
        enable = mkEnableOption "Bird Looking Glass Frontend Webserver";

        listenAddress = mkOption {
          type = types.str;
          default = "127.0.0.1:5000";
          description = lib.mdDoc "Address to listen on.";
        };

        proxyPort = mkOption {
          type = types.port;
          default = 8000;
          description = lib.mdDoc "Port bird-lg-proxy is running on.";
        };

        domain = mkOption {
          type = types.str;
          default = "";
          example = "dn42.lantian.pub";
          description = lib.mdDoc "Server name domain suffixes.";
        };

        servers = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [ "gigsgigscloud" "hostdare" ];
          description = lib.mdDoc "Server name prefixes.";
        };

        whois = mkOption {
          type = types.str;
          default = "whois.verisign-grs.com";
          description = lib.mdDoc "Whois server for queries.";
        };

        dnsInterface = mkOption {
          type = types.str;
          default = "asn.cymru.com";
          description = lib.mdDoc "DNS zone to query ASN information.";
        };

        bgpMapInfo = mkOption {
          type = types.listOf types.str;
          default = [ "asn" "as-name" "ASName" "descr" ];
          description = lib.mdDoc "Information displayed in bgpmap.";
        };

        titleBrand = mkOption {
          type = types.str;
          default = "Bird-lg Go";
          description = lib.mdDoc "Prefix of page titles in browser tabs.";
        };

        netSpecificMode = mkOption {
          type = types.str;
          default = "";
          example = "dn42";
          description = lib.mdDoc "Apply network-specific changes for some networks.";
        };

        protocolFilter = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [ "ospf" ];
          description = lib.mdDoc "Information displayed in bgpmap.";
        };

        nameFilter = mkOption {
          type = types.str;
          default = "";
          example = "^ospf";
          description = lib.mdDoc "Protocol names to hide in summary tables (RE2 syntax),";
        };

        timeout = mkOption {
          type = types.int;
          default = 120;
          description = lib.mdDoc "Time before request timed out, in seconds.";
        };

        navbar = {
          brand = mkOption {
            type = types.str;
            default = "Bird-lg Go";
            description = lib.mdDoc "Brand to show in the navigation bar .";
          };

          brandURL = mkOption {
            type = types.str;
            default = "/";
            description = lib.mdDoc "URL of the brand to show in the navigation bar.";
          };

          allServers = mkOption {
            type = types.str;
            default = "ALL Servers";
            description = lib.mdDoc "Text of 'All server' button in the navigation bar.";
          };

          allServersURL = mkOption {
            type = types.str;
            default = "all";
            description = lib.mdDoc "URL of 'All servers' button.";
          };
        };

        extraArgs = mkOption {
          type = types.lines;
          default = "";
          description = lib.mdDoc ''
            Extra parameters documented [here](https://github.com/xddxdd/bird-lg-go#frontend).
          '';
        };
      };

      proxy = {
        enable = mkEnableOption "Bird Looking Glass Proxy";

        listenAddress = mkOption {
          type = types.str;
          default = "127.0.0.1:8000";
          description = lib.mdDoc "Address to listen on.";
        };

        allowedIPs = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [ "192.168.25.52" "192.168.25.53" ];
          description = lib.mdDoc "List of IPs to allow (default all allowed).";
        };

        birdSocket = mkOption {
          type = types.str;
          default = "/run/bird.ctl";
          example = "/var/run/bird/bird.ctl";
          description = lib.mdDoc "Bird control socket path.";
        };

        traceroute = {
          binary = mkOption {
            type = types.str;
            default = "${pkgs.traceroute}/bin/traceroute";
            defaultText = literalExpression ''"''${pkgs.traceroute}/bin/traceroute"'';
            description = lib.mdDoc "Traceroute's binary path.";
          };

          rawOutput = mkOption {
            type = types.bool;
            default = false;
            description = lib.mdDoc "Display traceroute output in raw format.";
          };
        };

        extraArgs = mkOption {
          type = types.lines;
          default = "";
          description = lib.mdDoc ''
            Extra parameters documented [here](https://github.com/xddxdd/bird-lg-go#proxy).
          '';
        };
      };
    };
  };

  ###### implementation

  config = {
    systemd.services = {
      bird-lg-frontend = mkIf cfg.frontend.enable {
        enable = true;
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        description = "Bird Looking Glass Frontend Webserver";
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          ProtectSystem = "full";
          ProtectHome = "yes";
          MemoryDenyWriteExecute = "yes";
          User = cfg.user;
          Group = cfg.group;
        };
        script = ''
          ${cfg.package}/bin/frontend \
            --servers ${concatStringsSep "," cfg.frontend.servers } \
            --domain ${cfg.frontend.domain} \
            --listen ${cfg.frontend.listenAddress} \
            --proxy-port ${toString cfg.frontend.proxyPort} \
            --whois ${cfg.frontend.whois} \
            --dns-interface ${cfg.frontend.dnsInterface} \
            --bgpmap-info ${concatStringsSep "," cfg.frontend.bgpMapInfo } \
            --title-brand ${cfg.frontend.titleBrand} \
            --navbar-brand ${cfg.frontend.navbar.brand} \
            --navbar-brand-url ${cfg.frontend.navbar.brandURL} \
            --navbar-all-servers ${cfg.frontend.navbar.allServers} \
            --navbar-all-url ${cfg.frontend.navbar.allServersURL} \
            --net-specific-mode ${cfg.frontend.netSpecificMode} \
            --protocol-filter ${concatStringsSep "," cfg.frontend.protocolFilter } \
            --name-filter ${cfg.frontend.nameFilter} \
            --time-out ${toString cfg.frontend.timeout} \
            ${cfg.frontend.extraArgs}
        '';
      };

      bird-lg-proxy = mkIf cfg.proxy.enable {
        enable = true;
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        description = "Bird Looking Glass Proxy";
        serviceConfig = {
          Type = "simple";
          Restart = "on-failure";
          ProtectSystem = "full";
          ProtectHome = "yes";
          MemoryDenyWriteExecute = "yes";
          User = cfg.user;
          Group = cfg.group;
        };
        script = ''
          ${cfg.package}/bin/proxy \
          --allowed ${concatStringsSep "," cfg.proxy.allowedIPs } \
          --bird ${cfg.proxy.birdSocket} \
          --listen ${cfg.proxy.listenAddress} \
          --traceroute_bin ${cfg.proxy.traceroute.binary}
          --traceroute_raw ${boolToString cfg.proxy.traceroute.rawOutput}
          ${cfg.proxy.extraArgs}
        '';
      };
    };
    users = mkIf (cfg.frontend.enable || cfg.proxy.enable) {
      groups."bird-lg" = mkIf (cfg.group == "bird-lg") { };
      users."bird-lg" = mkIf (cfg.user == "bird-lg") {
        description = "Bird Looking Glass user";
        extraGroups = lib.optionals (config.services.bird2.enable) [ "bird2" ];
        group = cfg.group;
        isSystemUser = true;
      };
    };
  };
}
