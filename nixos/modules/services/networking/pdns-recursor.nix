{ config, lib, pkgs, ... }:

with lib;

let
  dataDir  = "/var/lib/pdns-recursor";
  username = "pdns-recursor";

  cfg   = config.services.pdns-recursor;
  zones = mapAttrsToList (zone: uri: "${zone}.=${uri}") cfg.forwardZones;

  configFile = pkgs.writeText "recursor.conf" ''
    local-address=${cfg.dns.address}
    local-port=${toString cfg.dns.port}
    allow-from=${concatStringsSep "," cfg.dns.allowFrom}

    webserver-address=${cfg.api.address}
    webserver-port=${toString cfg.api.port}
    webserver-allow-from=${concatStringsSep "," cfg.api.allowFrom}

    forward-zones=${concatStringsSep "," zones}
    export-etc-hosts=${if cfg.exportHosts then "yes" else "no"}
    dnssec=${cfg.dnssecValidation}
    serve-rfc1918=${if cfg.serveRFC1918 then "yes" else "no"}

    ${cfg.extraConfig}
  '';

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
      example = { eth = "127.0.0.1:5353"; };
      default = {};
      description = ''
        DNS zones to be forwarded to other servers.
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

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra options to be appended to the configuration file.
      '';
    };
  };

  config = mkIf cfg.enable {

    users.users."${username}" = {
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
          --socket-dir=${dataDir} \
          --disable-syslog
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
}
