{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.bird-lg;

  stringOrConcat = sep: v: if builtins.isString v then v else concatStringsSep sep v;

  frontend_args = let
    fe = cfg.frontend;
  in {
    "--servers" = concatStringsSep "," fe.servers;
    "--domain" = fe.domain;
    "--listen" = fe.listenAddress;
    "--proxy-port" = fe.proxyPort;
    "--whois" = fe.whois;
    "--dns-interface" = fe.dnsInterface;
    "--bgpmap-info" = concatStringsSep "," cfg.frontend.bgpMapInfo;
    "--title-brand" = fe.titleBrand;
    "--navbar-brand" = fe.navbar.brand;
    "--navbar-brand-url" = fe.navbar.brandURL;
    "--navbar-all-servers" = fe.navbar.allServers;
    "--navbar-all-url" = fe.navbar.allServersURL;
    "--net-specific-mode" = fe.netSpecificMode;
    "--protocol-filter" = concatStringsSep "," cfg.frontend.protocolFilter;
  };

  proxy_args = let
    px = cfg.proxy;
  in {
    "--allowed" = concatStringsSep "," px.allowedIPs;
    "--bird" = px.birdSocket;
    "--listen" = px.listenAddress;
    "--traceroute_bin" = px.traceroute.binary;
    "--traceroute_flags" = concatStringsSep " " px.traceroute.flags;
    "--traceroute_raw" = px.traceroute.rawOutput;
  };

  mkArgValue = value:
    if isString value
      then escapeShellArg value
      else if isBool value
        then boolToString value
        else toString value;

  filterNull = filterAttrs (_: v: v != "" && v != null && v != []);

  argsAttrToList = args: mapAttrsToList (name: value: "${name} " + mkArgValue value ) (filterNull args);
in
{
  options = {
    services.bird-lg = {
      package = mkPackageOption pkgs "bird-lg" { };

      user = mkOption {
        type = types.str;
        default = "bird-lg";
        description = "User to run the service.";
      };

      group = mkOption {
        type = types.str;
        default = "bird-lg";
        description = "Group to run the service.";
      };

      frontend = {
        enable = mkEnableOption "Bird Looking Glass Frontend Webserver";

        listenAddress = mkOption {
          type = types.str;
          default = "127.0.0.1:5000";
          description = "Address to listen on.";
        };

        proxyPort = mkOption {
          type = types.port;
          default = 8000;
          description = "Port bird-lg-proxy is running on.";
        };

        domain = mkOption {
          type = types.str;
          example = "dn42.lantian.pub";
          description = "Server name domain suffixes.";
        };

        servers = mkOption {
          type = types.listOf types.str;
          example = [ "gigsgigscloud" "hostdare" ];
          description = "Server name prefixes.";
        };

        whois = mkOption {
          type = types.str;
          default = "whois.verisign-grs.com";
          description = "Whois server for queries.";
        };

        dnsInterface = mkOption {
          type = types.str;
          default = "asn.cymru.com";
          description = "DNS zone to query ASN information.";
        };

        bgpMapInfo = mkOption {
          type = types.listOf types.str;
          default = [ "asn" "as-name" "ASName" "descr" ];
          description = "Information displayed in bgpmap.";
        };

        titleBrand = mkOption {
          type = types.str;
          default = "Bird-lg Go";
          description = "Prefix of page titles in browser tabs.";
        };

        netSpecificMode = mkOption {
          type = types.str;
          default = "";
          example = "dn42";
          description = "Apply network-specific changes for some networks.";
        };

        protocolFilter = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [ "ospf" ];
          description = "Information displayed in bgpmap.";
        };

        nameFilter = mkOption {
          type = types.str;
          default = "";
          example = "^ospf";
          description = "Protocol names to hide in summary tables (RE2 syntax),";
        };

        timeout = mkOption {
          type = types.int;
          default = 120;
          description = "Time before request timed out, in seconds.";
        };

        navbar = {
          brand = mkOption {
            type = types.str;
            default = "Bird-lg Go";
            description = "Brand to show in the navigation bar .";
          };

          brandURL = mkOption {
            type = types.str;
            default = "/";
            description = "URL of the brand to show in the navigation bar.";
          };

          allServers = mkOption {
            type = types.str;
            default = "ALL Servers";
            description = "Text of 'All server' button in the navigation bar.";
          };

          allServersURL = mkOption {
            type = types.str;
            default = "all";
            description = "URL of 'All servers' button.";
          };
        };

        extraArgs = mkOption {
          type = with types; either lines (listOf str);
          default = [ ];
          description = ''
            Extra parameters documented [here](https://github.com/xddxdd/bird-lg-go#frontend).

            :::{.note}
            Passing lines (plain strings) is deprecated in favour of passing lists of strings.
            :::
          '';
        };
      };

      proxy = {
        enable = mkEnableOption "Bird Looking Glass Proxy";

        listenAddress = mkOption {
          type = types.str;
          default = "127.0.0.1:8000";
          description = "Address to listen on.";
        };

        allowedIPs = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [ "192.168.25.52" "192.168.25.53" "192.168.0.0/24" ];
          description = "List of IPs or networks to allow (default all allowed).";
        };

        birdSocket = mkOption {
          type = types.str;
          default = "/var/run/bird/bird.ctl";
          description = "Bird control socket path.";
        };

        traceroute = {
          binary = mkOption {
            type = types.str;
            default = "${pkgs.traceroute}/bin/traceroute";
            defaultText = literalExpression ''"''${pkgs.traceroute}/bin/traceroute"'';
            description = "Traceroute's binary path.";
          };

          flags = mkOption {
            type = with types; listOf str;
            default = [ ];
            description = "Flags for traceroute process";
          };

          rawOutput = mkOption {
            type = types.bool;
            default = false;
            description = "Display traceroute output in raw format.";
          };
        };

        extraArgs = mkOption {
          type = with types; either lines (listOf str);
          default = [ ];
          description = ''
            Extra parameters documented [here](https://github.com/xddxdd/bird-lg-go#proxy).

            :::{.note}
            Passing lines (plain strings) is deprecated in favour of passing lists of strings.
            :::
          '';
        };
      };
    };
  };

  ###### implementation

  config = {

    warnings =
      lib.optional (cfg.frontend.enable  && builtins.isString cfg.frontend.extraArgs) ''
        Passing strings to `services.bird-lg.frontend.extraOptions' is deprecated. Please pass a list of strings instead.
      ''
      ++ lib.optional (cfg.proxy.enable  && builtins.isString cfg.proxy.extraArgs) ''
        Passing strings to `services.bird-lg.proxy.extraOptions' is deprecated. Please pass a list of strings instead.
      ''
    ;

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
            ${concatStringsSep " \\\n  " (argsAttrToList frontend_args)} \
            ${stringOrConcat " " cfg.frontend.extraArgs}
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
            ${concatStringsSep " \\\n  " (argsAttrToList proxy_args)} \
            ${stringOrConcat " " cfg.proxy.extraArgs}
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

  meta.maintainers = with lib.maintainers; [
    e1mo
    tchekda
  ];
}
