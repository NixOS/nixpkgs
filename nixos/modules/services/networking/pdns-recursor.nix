{ config, lib, pkgs, ... }:

with lib;

let
  dataDir  = "/var/lib/pdns-recursor";
  username = "pdns-recursor";

  cfg = config.services.pdns-recursor;

  oneOrMore  = type: with types; either type (listOf type);
  valueType  = with types; oneOf [ int str bool path ];
  configType = with types; attrsOf (nullOr (oneOrMore valueType));

  toBool    = val: if val then "yes" else "no";
  serialize = val: with types;
         if str.check       val then val
    else if int.check       val then toString val
    else if path.check      val then toString val
    else if bool.check      val then toBool val
    else if builtins.isList val then (concatMapStringsSep "," serialize val)
    else "";

  configFile = pkgs.writeText "recursor.conf"
    (concatStringsSep "\n"
      (flip mapAttrsToList cfg.settings
        (name: val: "${name}=${serialize val}")));

  mkDefaultAttrs = mapAttrs (n: v: mkDefault v);

in {
  options.services.pdns-recursor = {
    enable = mkEnableOption "PowerDNS Recursor, a recursive DNS server";

    dns.address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = ''
        IP address Recursor DNS server will bind to.
      '';
    };

    dns.port = mkOption {
      type = types.int;
      default = 53;
      description = ''
        Port number Recursor DNS server will bind to.
      '';
    };

    dns.allowFrom = mkOption {
      type = types.listOf types.str;
      default = [ "10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16" ];
      example = [ "0.0.0.0/0" ];
      description = ''
        IP address ranges of clients allowed to make DNS queries.
      '';
    };

    api.address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = ''
        IP address Recursor REST API server will bind to.
      '';
    };

    api.port = mkOption {
      type = types.int;
      default = 8082;
      description = ''
        Port number Recursor REST API server will bind to.
      '';
    };

    api.allowFrom = mkOption {
      type = types.listOf types.str;
      default = [ "0.0.0.0/0" ];
      description = ''
        IP address ranges of clients allowed to make API requests.
      '';
    };

    exportHosts = mkOption {
      type = types.bool;
      default = false;
      description = ''
       Whether to export names and IP addresses defined in /etc/hosts.
      '';
    };

    forwardZones = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        DNS zones to be forwarded to other authoritative servers.
      '';
    };

    forwardZonesRecurse = mkOption {
      type = types.attrs;
      example = { eth = "127.0.0.1:5353"; };
      default = {};
      description = ''
        DNS zones to be forwarded to other recursive servers.
      '';
    };

    dnssecValidation = mkOption {
      type = types.enum ["off" "process-no-validate" "process" "log-fail" "validate"];
      default = "validate";
      description = ''
        Controls the level of DNSSEC processing done by the PowerDNS Recursor.
        See https://doc.powerdns.com/md/recursor/dnssec/ for a detailed explanation.
      '';
    };

    serveRFC1918 = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to directly resolve the RFC1918 reverse-mapping domains:
        <literal>10.in-addr.arpa</literal>,
        <literal>168.192.in-addr.arpa</literal>,
        <literal>16-31.172.in-addr.arpa</literal>
        This saves load on the AS112 servers.
      '';
    };

    settings = mkOption {
      type = configType;
      default = { };
      example = literalExample ''
        {
          loglevel = 8;
          log-common-errors = true;
        }
      '';
      description = ''
        PowerDNS Recursor settings. Use this option to configure Recursor
        settings not exposed in a NixOS option or to bypass one.
        See the full documentation at
        <link xlink:href="https://doc.powerdns.com/recursor/settings.html"/>
        for the available options.
      '';
    };

    luaConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        The content Lua configuration file for PowerDNS Recursor. See
        <link xlink:href="https://doc.powerdns.com/recursor/lua-config/index.html"/>.
      '';
    };
  };

  config = mkIf cfg.enable {

    services.pdns-recursor.settings = mkDefaultAttrs {
      local-address = cfg.dns.address;
      local-port    = cfg.dns.port;
      allow-from    = cfg.dns.allowFrom;

      webserver-address    = cfg.api.address;
      webserver-port       = cfg.api.port;
      webserver-allow-from = cfg.api.allowFrom;

      forward-zones         = mapAttrsToList (zone: uri: "${zone}.=${uri}") cfg.forwardZones;
      forward-zones-recurse = mapAttrsToList (zone: uri: "${zone}.=${uri}") cfg.forwardZonesRecurse;
      export-etc-hosts = cfg.exportHosts;
      dnssec           = cfg.dnssecValidation;
      serve-rfc1918    = cfg.serveRFC1918;
      lua-config-file  = pkgs.writeText "recursor.lua" cfg.luaConfig;

      log-timestamp  = false;
      disable-syslog = true;
    };

    users.users.${username} = {
      home = dataDir;
      createHome = true;
      uid = config.ids.uids.pdns-recursor;
      description = "PowerDNS Recursor daemon user";
    };

    systemd.services.pdns-recursor = {
      unitConfig.Documentation = "man:pdns_recursor(1) man:rec_control(1)";
      description = "PowerDNS recursive server";
      wantedBy = [ "multi-user.target" ];
      after    = [ "network.target" ];

      serviceConfig = {
        User = username;
        Restart    ="on-failure";
        RestartSec = "5";
        PrivateTmp = true;
        PrivateDevices = true;
        AmbientCapabilities = "cap_net_bind_service";
        ExecStart = ''${pkgs.pdns-recursor}/bin/pdns_recursor \
          --config-dir=${dataDir} \
          --socket-dir=${dataDir}
        '';
      };

      preStart = ''
        # Link configuration file into recursor home directory
        configPath=${dataDir}/recursor.conf
        if [ "$(realpath $configPath)" != "${configFile}" ]; then
          rm -f $configPath
          ln -s ${configFile} $configPath
        fi
      '';
    };
  };

  imports = [
   (mkRemovedOptionModule [ "services" "pdns-recursor" "extraConfig" ]
     "To change extra Recursor settings use services.pdns-recursor.settings instead.")
  ];

}
