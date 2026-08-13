{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.bird-lg;

  stringOrConcat = sep: v: if builtins.isString v then v else lib.concatStringsSep sep v;

  frontend_args =
    let
      fe = cfg.frontend;
    in
    {
      "--servers" = lib.concatStringsSep "," fe.servers;
      "--domain" = fe.domain;
      "--listen" = stringOrConcat "," fe.listenAddresses;
      "--proxy-port" = fe.proxyPort;
      "--whois" = fe.whois;
      "--dns-interface" = fe.dnsInterface;
      "--bgpmap-info" = lib.concatStringsSep "," cfg.frontend.bgpMapInfo;
      "--title-brand" = fe.titleBrand;
      "--navbar-brand" = fe.navbar.brand;
      "--navbar-brand-url" = fe.navbar.brandURL;
      "--navbar-all-servers" = fe.navbar.allServers;
      "--navbar-all-url" = fe.navbar.allServersURL;
      "--net-specific-mode" = fe.netSpecificMode;
      "--protocol-filter" = lib.concatStringsSep "," cfg.frontend.protocolFilter;
    };

  proxy_args =
    let
      px = cfg.proxy;
    in
    {
      "--allowed" = lib.concatStringsSep "," px.allowedIPs;
      "--bird" = px.birdSocket;
      "--listen" = stringOrConcat "," px.listenAddresses;
      "--traceroute_bin" = px.traceroute.binary;
      "--traceroute_flags" = lib.concatStringsSep " " px.traceroute.flags;
      "--traceroute_raw" = px.traceroute.rawOutput;
    };

  mkArgValue =
    value:
    if lib.isString value then
      lib.escapeShellArg value
    else if lib.isBool value then
      lib.boolToString value
    else
      toString value;

  filterNull = lib.filterAttrs (_: v: v != "" && v != null && v != [ ]);

  argsAttrToList =
    args: lib.mapAttrsToList (name: value: "${name} " + mkArgValue value) (filterNull args);
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "bird-lg" "frontend" "listenAddress" ]
      [ "services" "bird-lg" "frontend" "listenAddresses" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "bird-lg" "proxy" "listenAddress" ]
      [ "services" "bird-lg" "proxy" "listenAddresses" ]
    )
  ];

  options = {
    services.bird-lg = {
      package = lib.mkPackageOption pkgs "bird-lg" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "bird-lg";
        description = "User to run the service.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "bird-lg";
        description = "Group to run the service.";
      };

      frontend = {
        enable = lib.mkEnableOption "Bird Looking Glass Frontend Webserver";

        listenAddresses = lib.mkOption {
          type = with lib.types; either str (listOf str);
          default = "127.0.0.1:5000";
          description = "Address to listen on.";
        };

        proxyPort = lib.mkOption {
          type = lib.types.port;
          default = 8000;
          description = "Port bird-lg-proxy is running on.";
        };

        domain = lib.mkOption {
          type = lib.types.str;
          example = "dn42.lantian.pub";
          description = "Server name domain suffixes.";
        };

        servers = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          example = [
            "gigsgigscloud"
            "hostdare"
          ];
          description = "Server name prefixes.";
        };

        whois = lib.mkOption {
          type = lib.types.str;
          default = "whois.verisign-grs.com";
          description = "Whois server for queries.";
        };

        dnsInterface = lib.mkOption {
          type = lib.types.str;
          default = "asn.cymru.com";
          description = "DNS zone to query ASN information.";
        };

        bgpMapInfo = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "asn"
            "as-name"
            "ASName"
            "descr"
          ];
          description = "Information displayed in bgpmap.";
        };

        titleBrand = lib.mkOption {
          type = lib.types.str;
          default = "Bird-lg Go";
          description = "Prefix of page titles in browser tabs.";
        };

        netSpecificMode = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "dn42";
          description = "Apply network-specific changes for some networks.";
        };

        protocolFilter = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [ "ospf" ];
          description = "Information displayed in bgpmap.";
        };

        nameFilter = lib.mkOption {
          type = lib.types.str;
          default = "";
          example = "^ospf";
          description = "Protocol names to hide in summary tables (RE2 syntax),";
        };

        timeout = lib.mkOption {
          type = lib.types.int;
          default = 120;
          description = "Time before request timed out, in seconds.";
        };

        navbar = {
          brand = lib.mkOption {
            type = lib.types.str;
            default = "Bird-lg Go";
            description = "Brand to show in the navigation bar .";
          };

          brandURL = lib.mkOption {
            type = lib.types.str;
            default = "/";
            description = "URL of the brand to show in the navigation bar.";
          };

          allServers = lib.mkOption {
            type = lib.types.str;
            default = "ALL Servers";
            description = "Text of 'All server' button in the navigation bar.";
          };

          allServersURL = lib.mkOption {
            type = lib.types.str;
            default = "all";
            description = "URL of 'All servers' button.";
          };
        };

        extraArgs = lib.mkOption {
          type = with lib.types; listOf str;
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
        enable = lib.mkEnableOption "Bird Looking Glass Proxy";

        listenAddresses = lib.mkOption {
          type = with lib.types; either str (listOf str);
          default = "127.0.0.1:8000";
          description = "Address to listen on.";
        };

        allowedIPs = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "192.168.25.52"
            "192.168.25.53"
            "192.168.0.0/24"
          ];
          description = "List of IPs or networks to allow (default all allowed).";
        };

        birdSocket = lib.mkOption {
          type = lib.types.str;
          default = "/var/run/bird/bird.ctl";
          description = "Bird control socket path.";
        };

        traceroute = {
          binary = lib.mkOption {
            type = lib.types.str;
            default = "${pkgs.traceroute}/bin/traceroute";
            defaultText = lib.literalExpression ''"''${pkgs.traceroute}/bin/traceroute"'';
            description = "Traceroute's binary path.";
          };

          flags = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            description = "Flags for traceroute process";
          };

          rawOutput = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Display traceroute output in raw format.";
          };
        };

        extraArgs = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          description = ''
            Extra parameters documented [here](https://github.com/xddxdd/bird-lg-go#proxy).
          '';
        };
      };
    };
  };

  ###### implementation

  config = {
    systemd.services = {
      bird-lg-frontend = lib.mkIf cfg.frontend.enable {
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
            ${lib.concatStringsSep " \\\n  " (argsAttrToList frontend_args)} \
            ${stringOrConcat " " cfg.frontend.extraArgs}
        '';
      };

      bird-lg-proxy = lib.mkIf cfg.proxy.enable {
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
            ${lib.concatStringsSep " \\\n  " (argsAttrToList proxy_args)} \
            ${stringOrConcat " " cfg.proxy.extraArgs}
        '';
      };
    };
    users = lib.mkIf (cfg.frontend.enable || cfg.proxy.enable) {
      groups."bird-lg" = lib.mkIf (cfg.group == "bird-lg") { };
      users."bird-lg" = lib.mkIf (cfg.user == "bird-lg") {
        description = "Bird Looking Glass user";
        extraGroups = lib.optionals (config.services.bird.enable) [ "bird" ];
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
