{ config, lib, pkgs, ... }:

with lib;

let
  cfgs = config.services;
  cfg  = cfgs.dnschain;

  dataDir  = "/var/lib/dnschain";
  username = "dnschain";

  configFile = pkgs.writeText "dnschain.conf" ''
    [log]
    level = info

    [dns]
    host = ${cfg.dns.address}
    port = ${toString cfg.dns.port}
    oldDNSMethod = NO_OLD_DNS
    externalIP = ${cfg.dns.externalAddress}

    [http]
    host = ${cfg.api.hostname}
    port = ${toString cfg.api.port}
    tlsPort = ${toString cfg.api.tlsPort}

    ${cfg.extraConfig}
  '';

in

{

  ###### interface

  options = {

    services.dnschain = {

      enable = mkEnableOption ''
        DNSChain, a blockchain based DNS + HTTP server.
        To resolve .bit domains set <literal>services.namecoind.enable = true;</literal>
        and an RPC username/password.
      '';

      dns.address = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = ''
          The IP address the DNSChain resolver will bind to.
          Leave this unchanged if you do not wish to directly expose the resolver.
        '';
      };

      dns.externalAddress = mkOption {
        type = types.str;
        default = cfg.dns.address;
        description = ''
           The IP address used by clients to reach the resolver and the value of
           the <literal>namecoin.dns</literal> record. Set this in case the bind address
           is not the actual IP address (e.g. the machine is behind a NAT).
        '';
      };

      dns.port = mkOption {
        type = types.int;
        default = 5333;
        description = ''
          The port the DNSChain resolver will bind to.
        '';
      };

      api.hostname = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          The hostname (or IP address) the DNSChain API server will bind to.
        '';
      };

      api.port = mkOption {
        type = types.int;
        default = 8080;
        description = ''
          The port the DNSChain API server (HTTP) will bind to.
        '';
      };

      api.tlsPort = mkOption {
        type = types.int;
        default = 4433;
        description = ''
          The port the DNSChain API server (HTTPS) will bind to.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          [log]
          level = debug
        '';
        description = ''
          Additional options that will be appended to the configuration file.
        '';
      };

    };

    services.dnsmasq.resolveDNSChainQueries = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Resolve <literal>.bit</literal> top-level domains using DNSChain and namecoin.
      '';
    };

    services.pdns-recursor.resolveDNSChainQueries = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Resolve <literal>.bit</literal> top-level domains using DNSChain and namecoin.
      '';
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.dnsmasq.servers = optionals cfgs.dnsmasq.resolveDNSChainQueries
      [ "/.bit/127.0.0.1#${toString cfg.dns.port}"
        "/.dns/127.0.0.1#${toString cfg.dns.port}"
      ];

    services.pdns-recursor.forwardZones = mkIf cfgs.pdns-recursor.resolveDNSChainQueries
      { bit = "127.0.0.1:${toString cfg.dns.port}";
        dns = "127.0.0.1:${toString cfg.dns.port}";
      };

    users.extraUsers = singleton {
      name = username;
      description = "DNSChain daemon user";
      home = dataDir;
      createHome = true;
      uid = config.ids.uids.dnschain;
      extraGroups = optional cfgs.namecoind.enable "namecoin";
    };

    systemd.services.dnschain = {
      description = "DNSChain daemon";
      after    = optional cfgs.namecoind.enable "namecoind.target";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "dnschain";
        Restart = "on-failure";
        ExecStart = "${pkgs.dnschain}/bin/dnschain";
      };

      preStart = ''
        # Link configuration file into dnschain home directory
        configPath=${dataDir}/.dnschain/dnschain.conf
        mkdir -p ${dataDir}/.dnschain
        if [ "$(realpath $configPath)" != "${configFile}" ]; then
          rm -f $configPath
          ln -s ${configFile} $configPath
        fi
      '';
    };

  };

}
