{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.i2pd;

  homeDir = "/var/lib/i2pd";

  mkEndpointOpt = name: addr: port: {
    enable = mkEnableOption name;
    name = mkOption {
      type = types.str;
      default = name;
      description = "The endpoint name.";
    };
    address = mkOption {
      type = types.str;
      default = addr;
      description = "Bind address for ${name} endpoint. Default: " + addr;
    };
    port = mkOption {
      type = types.int;
      default = port;
      description = "Bind port for ${name} endoint. Default: " + toString port;
    };
  };

  mkKeyedEndpointOpt = name: addr: port: keyFile:
  (mkEndpointOpt name addr port) // {
    keys = mkOption {
      type = types.str;
      default = "";
      description = ''
        File to persist ${lib.toUpper name} keys.
      '';
    };
  };

  commonTunOpts = let
    i2cpOpts = {
      length = mkOption {
        type = types.int;
        description = "Guaranteed minimum hops.";
        default = 3;
      };
      quantity = mkOption {
        type = types.int;
        description = "Number of simultaneous tunnels.";
        default = 5;
      };
    };
  in name: {
    outbound = i2cpOpts;
    inbound = i2cpOpts;
    crypto.tagsToSend = mkOption {
      type = types.int;
      description = "Number of ElGamal/AES tags to send.";
      default = 40;
    };
   destination = mkOption {
      type = types.str;
      description = "Remote endpoint, I2P hostname or b32.i2p address.";
    };
    keys = mkOption {
      type = types.str;
      default = name + "-keys.dat";
      description = "Keyset used for tunnel identity.";
    };
  } // mkEndpointOpt name "127.0.0.1" 0;

  i2pdConf = pkgs.writeText "i2pd.conf"
  ''
  ipv4 = ${boolToString cfg.enableIPv4}
  ipv6 = ${boolToString cfg.enableIPv6}
  notransit = ${boolToString cfg.notransit}
  floodfill = ${boolToString cfg.floodfill}
  netid = ${toString cfg.netid}
  ${if isNull cfg.bandwidth then "" else "bandwidth = ${toString cfg.bandwidth}" }
  ${if isNull cfg.port then "" else "port = ${toString cfg.port}"}

  [limits]
  transittunnels = ${toString cfg.limits.transittunnels}

  [upnp]
  enabled = ${boolToString cfg.upnp.enable}
  name = ${cfg.upnp.name}

  [precomputation]
  elgamal = ${boolToString cfg.precomputation.elgamal}

  [reseed]
  verify = ${boolToString cfg.reseed.verify}
  file = ${cfg.reseed.file}
  urls = ${builtins.concatStringsSep "," cfg.reseed.urls}

  [addressbook]
  defaulturl = ${cfg.addressbook.defaulturl}
  subscriptions = ${builtins.concatStringsSep "," cfg.addressbook.subscriptions}
  ${flip concatMapStrings
      (collect (proto: proto ? port && proto ? address && proto ? name) cfg.proto)
      (proto: let portStr = toString proto.port; in
        ''
          [${proto.name}]
          enabled = ${boolToString proto.enable}
          address = ${proto.address}
          port = ${toString proto.port}
          ${if proto ? keys then "keys = ${proto.keys}" else ""}
          ${if proto ? auth then "auth = ${boolToString proto.auth}" else ""}
          ${if proto ? user then "user = ${proto.user}" else ""}
          ${if proto ? pass then "pass = ${proto.pass}" else ""}
          ${if proto ? outproxy then "outproxy = ${proto.outproxy}" else ""}
          ${if proto ? outproxyPort then "outproxyport = ${toString proto.outproxyPort}" else ""}
        '')
      }
  '';

  i2pdTunnelConf = pkgs.writeText "i2pd-tunnels.conf" ''
  ${flip concatMapStrings
    (collect (tun: tun ? port && tun ? destination) cfg.outTunnels)
    (tun: let portStr = toString tun.port; in ''
  [${tun.name}]
  type = client
  destination = ${tun.destination}
  keys = ${tun.keys}
  address = ${tun.address}
  port = ${toString tun.port}
  inbound.length = ${toString tun.inbound.length}
  outbound.length = ${toString tun.outbound.length}
  inbound.quantity = ${toString tun.inbound.quantity}
  outbound.quantity = ${toString tun.outbound.quantity}
  crypto.tagsToSend = ${toString tun.crypto.tagsToSend}
  '')
  }
  ${flip concatMapStrings
    (collect (tun: tun ? port && tun ? host) cfg.inTunnels)
    (tun: let portStr = toString tun.port; in ''
  [${tun.name}]
  type = server
  destination = ${tun.destination}
  keys = ${tun.keys}
  host = ${tun.address}
  port = ${tun.port}
  inport = ${tun.inPort}
  accesslist = ${builtins.concatStringsSep "," tun.accessList}
  '')
  }
  '';

  i2pdSh = pkgs.writeScriptBin "i2pd" ''
    #!/bin/sh
    ${pkgs.i2pd}/bin/i2pd \
      ${if isNull cfg.extIp then "" else "--host="+cfg.extIp} \
      --conf=${i2pdConf} \
      --tunconf=${i2pdTunnelConf}
  '';

in

{

  ###### interface

  options = {

    services.i2pd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables I2Pd as a running service upon activation.
          Please read http://i2pd.readthedocs.io/en/latest/ for further
          configuration help.
        '';
      };

      extIp = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          Your external IP.
        '';
      };

      notransit = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Tells the router to not accept transit tunnels during startup.
        '';
      };

      floodfill = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If the router is declared to be unreachable and needs introduction nodes.
        '';
      };

      netid = mkOption {
        type = types.int;
        default = 2;
        description = ''
          I2P overlay netid.
        '';
      };

      bandwidth = mkOption {
        type = with types; nullOr int;
        default = null;
        description = ''
           Set a router bandwidth limit integer in KBps.
           If not set, i2pd defaults to 32KBps.
        '';
      };

      port = mkOption {
        type = with types; nullOr int;
        default = null;
        description = ''
          I2P listen port. If no one is given the router will pick between 9111 and 30777.
        '';
      };

      enableIPv4 = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Enables IPv4 connectivity. Enabled by default.
        '';
      };

      enableIPv6 = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables IPv6 connectivity. Disabled by default.
        '';
      };

      upnp = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enables UPnP.
          '';
        };

        name = mkOption {
          type = types.str;
          default = "I2Pd";
          description = ''
            Name i2pd appears in UPnP forwardings list.
          '';
        };
      };

      precomputation.elgamal = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Use ElGamal precomputated tables.
        '';
      };

      reseed = {
        verify = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Request SU3 signature verification
          '';
        };

        file = mkOption {
          type = types.str;
          default = "";
          description = ''
            Full path to SU3 file to reseed from
          '';
        };

        urls = mkOption {
          type = with types; listOf str;
          default = [
            "https://reseed.i2p-project.de/"
            "https://i2p.mooo.com/netDb/"
            "https://netdb.i2p2.no/"
            "https://us.reseed.i2p2.no:444/"
            "https://uk.reseed.i2p2.no:444/"
            "https://i2p.manas.ca:8443/"
          ];
          description = ''
            Reseed URLs
          '';
        };
      };

      addressbook = {
       defaulturl = mkOption {
          type = types.str;
          default = "http://joajgazyztfssty4w2on5oaqksz6tqoxbduy553y34mf4byv6gpq.b32.i2p/export/alive-hosts.txt";
          description = ''
            AddressBook subscription URL for initial setup
          '';
        };
       subscriptions = mkOption {
          type = with types; listOf str;
          default = [
            "http://inr.i2p/export/alive-hosts.txt"
            "http://i2p-projekt.i2p/hosts.txt"
            "http://stats.i2p/cgi-bin/newhosts.txt"
          ];
          description = ''
            AddressBook subscription URLs
          '';
        };
      };

      limits.transittunnels = mkOption {
        type = types.int;
        default = 2500;
        description = ''
          Maximum number of active transit sessions
        '';
      };

      proto.http = (mkEndpointOpt "http" "127.0.0.1" 7070) // {
        auth = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable authentication for webconsole.
          '';
        };
        user = mkOption {
          type = types.str;
          default = "i2pd";
          description = ''
            Username for webconsole access
          '';
        };
        pass = mkOption {
          type = types.str;
          default = "i2pd";
          description = ''
            Password for webconsole access.
          '';
        };
      };

      proto.httpProxy = mkKeyedEndpointOpt "httpproxy" "127.0.0.1" 4446 "";
      proto.socksProxy = (mkKeyedEndpointOpt "socksproxy" "127.0.0.1" 4447 "")
      // {
        outproxy = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Upstream outproxy bind address.";
        };
        outproxyPort = mkOption {
          type = types.int;
          default = 4444;
          description = "Upstream outproxy bind port.";
        };
      };

      proto.sam = mkEndpointOpt "sam" "127.0.0.1" 7656;
      proto.bob = mkEndpointOpt "bob" "127.0.0.1" 2827;
      proto.i2cp = mkEndpointOpt "i2cp" "127.0.0.1" 7654;
      proto.i2pControl = mkEndpointOpt "i2pcontrol" "127.0.0.1" 7650;

      outTunnels = mkOption {
        default = {};
        type = with types; loaOf (submodule (
          { name, config, ... }: {
            options = commonTunOpts name;
            config = {
              name = mkDefault name;
            };
          }
        ));
        description = ''
          Connect to someone as a client and establish a local accept endpoint
        '';
      };

      inTunnels = mkOption {
        default = {};
        type = with types; loaOf (submodule (
          { name, config, ... }: {
            options = {
              inPort = mkOption {
                type = types.int;
                default = 0;
                description = "Service port. Default to the tunnel's listen port.";
              };
              accessList = mkOption {
                type = with types; listOf str;
                default = [];
                description = "I2P nodes that are allowed to connect to this service.";
              };
            } // commonTunOpts name;
            config = {
              name = mkDefault name;
            };
          }
        ));
        description = ''
          Serve something on I2P network at port and delegate requests to address inPort.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers.i2pd = {
      group = "i2pd";
      description = "I2Pd User";
      home = homeDir;
      createHome = true;
      uid = config.ids.uids.i2pd;
    };

    users.extraGroups.i2pd.gid = config.ids.gids.i2pd;

    systemd.services.i2pd = {
      description = "Minimal I2P router";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
      {
        User = "i2pd";
        WorkingDirectory = homeDir;
        Restart = "on-abort";
        ExecStart = "${i2pdSh}/bin/i2pd";
      };
    };
  };
}
