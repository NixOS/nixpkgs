{ config, lib, pkgs, ... }:

with lib;

let

  pkg = pkgs.cjdns;

  cfg = config.services.cjdns;

  connectToSubmodule =
  { options, ... }:
  { options =
    { password = mkOption {
      type = types.str;
      description = "Authorized password to the opposite end of the tunnel.";
      };
      publicKey = mkOption {
        type = types.str;
        description = "Public key at the opposite end of the tunnel.";
      };
      hostname = mkOption {
        default = "";
        example = "foobar.hype";
        type = types.str;
        description = "Optional hostname to add to /etc/hosts; prevents reverse lookup failures.";
      };
    };
  };

  # Additional /etc/hosts entries for peers with an associated hostname
  cjdnsExtraHosts = import (pkgs.runCommand "cjdns-hosts" {}
    # Generate a builder that produces an output usable as a Nix string value
    ''
      exec >$out
      echo \'\'
      ${concatStringsSep "\n" (mapAttrsToList (k: v:
          optionalString (v.hostname != "")
            "echo $(${pkgs.cjdns}/bin/publictoip6 ${v.publicKey}) ${v.hostname}")
          (cfg.ETHInterface.connectTo // cfg.UDPInterface.connectTo))}
      echo \'\'
    '');

  parseModules = x:
    x // { connectTo = mapAttrs (name: value: { inherit (value) password publicKey; }) x.connectTo; };

  # would be nice to  merge 'cfg' with a //,
  # but the json nesting is wacky.
  cjdrouteConf = builtins.toJSON ( {
    admin = {
      bind = cfg.admin.bind;
      password = "@CJDNS_ADMIN_PASSWORD@";
    };
    authorizedPasswords = map (p: { password = p; }) cfg.authorizedPasswords;
    interfaces = {
      ETHInterface = if (cfg.ETHInterface.bind != "") then [ (parseModules cfg.ETHInterface) ] else [ ];
      UDPInterface = if (cfg.UDPInterface.bind != "") then [ (parseModules cfg.UDPInterface) ] else [ ];
    };

    privateKey = "@CJDNS_PRIVATE_KEY@";

    resetAfterInactivitySeconds = 100;

    router = {
      interface = { type = "TUNInterface"; };
      ipTunnel = {
        allowedConnections = [];
        outgoingConnections = [];
      };
    };

    security = [ { exemptAngel = 1; setuser = "nobody"; } ];

  });

in

{
  options = {

    services.cjdns = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the cjdns network encryption
          and routing engine. A file at /etc/cjdns.keys will
          be created if it does not exist to contain a random
          secret key that your IPv6 address will be derived from.
        '';
      };

      confFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/etc/cjdroute.conf";
        description = ''
          Ignore all other cjdns options and load configuration from this file.
        '';
      };

      authorizedPasswords = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [
          "snyrfgkqsc98qh1y4s5hbu0j57xw5s0"
          "z9md3t4p45mfrjzdjurxn4wuj0d8swv"
          "49275fut6tmzu354pq70sr5b95qq0vj"
        ];
        description = ''
          Any remote cjdns nodes that offer these passwords on
          connection will be allowed to route through this node.
        '';
      };

      admin = {
        bind = mkOption {
          type = types.str;
          default = "127.0.0.1:11234";
          description = ''
            Bind the administration port to this address and port.
          '';
        };
      };

      UDPInterface = {
        bind = mkOption {
          type = types.str;
          default = "";
          example = "192.168.1.32:43211";
          description = ''
            Address and port to bind UDP tunnels to.
          '';
         };
        connectTo = mkOption {
          type = types.attrsOf ( types.submodule ( connectToSubmodule ) );
          default = { };
          example = {
            "192.168.1.1:27313" = {
              hostname = "homer.hype";
              password = "5kG15EfpdcKNX3f2GSQ0H1HC7yIfxoCoImnO5FHM";
              publicKey = "371zpkgs8ss387tmr81q04mp0hg1skb51hw34vk1cq644mjqhup0.k";
            };
          };
          description = ''
            Credentials for making UDP tunnels.
          '';
        };
      };

      ETHInterface = {
        bind = mkOption {
          type = types.str;
          default = "";
          example = "eth0";
          description =
            ''
              Bind to this device for native ethernet operation.
              <literal>all</literal> is a pseudo-name which will try to connect to all devices.
            '';
        };

        beacon = mkOption {
          type = types.int;
          default = 2;
          description = ''
            Auto-connect to other cjdns nodes on the same network.
            Options:
              0: Disabled.
              1: Accept beacons, this will cause cjdns to accept incoming
                 beacon messages and try connecting to the sender.
              2: Accept and send beacons, this will cause cjdns to broadcast
                 messages on the local network which contain a randomly
                 generated per-session password, other nodes which have this
                 set to 1 or 2 will hear the beacon messages and connect
                 automatically.
          '';
        };

        connectTo = mkOption {
          type = types.attrsOf ( types.submodule ( connectToSubmodule ) );
          default = { };
          example = {
            "01:02:03:04:05:06" = {
              hostname = "homer.hype";
              password = "5kG15EfpdcKNX3f2GSQ0H1HC7yIfxoCoImnO5FHM";
              publicKey = "371zpkgs8ss387tmr81q04mp0hg1skb51hw34vk1cq644mjqhup0.k";
            };
          };
          description = ''
            Credentials for connecting look similar to UDP credientials
            except they begin with the mac address.
          '';
        };
      };

      addExtraHosts = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to add cjdns peers with an associated hostname to
          <filename>/etc/hosts</filename>.  Beware that enabling this
          incurs heavy eval-time costs.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    boot.kernelModules = [ "tun" ];

    # networking.firewall.allowedUDPPorts = ...

    systemd.services.cjdns = {
      description = "cjdns: routing engine designed for security, scalability, speed and ease of use";
      wantedBy = [ "multi-user.target" "sleep.target"];
      after = [ "network-online.target" ];
      bindsTo = [ "network-online.target" ];

      preStart = if cfg.confFile != null then "" else ''
        [ -e /etc/cjdns.keys ] && source /etc/cjdns.keys

        if [ -z "$CJDNS_PRIVATE_KEY" ]; then
            shopt -s lastpipe
            ${pkg}/bin/makekeys | { read private ipv6 public; }

            umask 0077
            echo "CJDNS_PRIVATE_KEY=$private" >> /etc/cjdns.keys
            echo -e "CJDNS_IPV6=$ipv6\nCJDNS_PUBLIC_KEY=$public" > /etc/cjdns.public

            chmod 600 /etc/cjdns.keys
            chmod 444 /etc/cjdns.public
        fi

        if [ -z "$CJDNS_ADMIN_PASSWORD" ]; then
            echo "CJDNS_ADMIN_PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 96)" \
                >> /etc/cjdns.keys
        fi
      '';

      script = (
        if cfg.confFile != null then "${pkg}/bin/cjdroute < ${cfg.confFile}" else
          ''
            source /etc/cjdns.keys
            echo '${cjdrouteConf}' | sed \
                -e "s/@CJDNS_ADMIN_PASSWORD@/$CJDNS_ADMIN_PASSWORD/g" \
                -e "s/@CJDNS_PRIVATE_KEY@/$CJDNS_PRIVATE_KEY/g" \
                | ${pkg}/bin/cjdroute
         ''
      );

      serviceConfig = {
        Type = "forking";
        Restart = "always";
        StartLimitInterval = 0;
        RestartSec = 1;
        CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
        AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_RAW";
        ProtectSystem = true;
        MemoryDenyWriteExecute = true;
        ProtectHome = true;
        PrivateTmp = true;
      };
    };

    networking.extraHosts = mkIf cfg.addExtraHosts cjdnsExtraHosts;

    assertions = [
      { assertion = ( cfg.ETHInterface.bind != "" || cfg.UDPInterface.bind != "" || cfg.confFile != null );
        message = "Neither cjdns.ETHInterface.bind nor cjdns.UDPInterface.bind defined.";
      }
      { assertion = config.networking.enableIPv6;
        message = "networking.enableIPv6 must be enabled for CJDNS to work";
      }
    ];

  };

}
