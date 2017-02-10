{ config, lib, pkgs, ... }:

with lib;

let

  pkg = pkgs.cjdns;

  cfgs = config.services.cjdns.networks;

  enabledCfgs = filterAttrs (name: cfg: cfg.enable) cfgs;

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

  udpSubmodule =
  { options, ... }:
  { options =
    { bind = mkOption {
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
  };

  ethSubmodule =
  { options, ... }:
  { options =
    { bind = mkOption {
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
  };

  cjdnsSubmodule =
  { options, ... }:
  { options =
    { enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable this cjdns network.
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

      UDPInterfaces = mkOption {
        default = [];
        example = [
          {
            bind = "192.168.1.32:43211";
            connectTo = {
              "192.168.1.1:27313" = {
                hostname = "homer.hype";
                password = "5kG15EfpdcKNX3f2GSQ0H1HC7yIfxoCoImnO5FHM";
                publicKey = "371zpkgs8ss387tmr81q04mp0hg1skb51hw34vk1cq644mjqhup0.k";
              };
            };
          }
        ];
        description = ''
          List of UDP interfaces. Each element should be an attribute set
          specifying the options for each UDP interface (i.e., for each
          UDP port that you want to listen on).

          Most users only need one UDP interface.
        '';
        type = types.listOf (types.submodule udpSubmodule);
      };

      ETHInterfaces = mkOption {
        default = [];
        example = [
          {
            bind = "eth0";
            connectTo = {
              "01:02:03:04:05:06" = {
                hostname = "homer.hype";
                password = "5kG15EfpdcKNX3f2GSQ0H1HC7yIfxoCoImnO5FHM";
                publicKey = "371zpkgs8ss387tmr81q04mp0hg1skb51hw34vk1cq644mjqhup0.k";
              };
            };
          }
        ];
        description = ''
          List of native ethernet interfaces. Each element should be an
          attribute set specifying the options for each native ethernet
          interface that you want to listen on.

          If you want to use all ethernet interfaces, you can define only one
          element, binding to the pseudo-interface name <literal>all</literal>.
        '';
        type = types.listOf (types.submodule ethSubmodule);
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

  # Additional /etc/hosts entries for peers with an associated hostname
  cjdnsExtraHosts = hosts: import (pkgs.runCommand "cjdns-hosts" {}
    # Generate a builder that produces an output usable as a Nix string value
    ''
      exec >$out
      echo \'\'
      ${concatStringsSep "\n" (mapAttrsToList (k: v:
            "echo $(${pkgs.cjdns}/bin/publictoip6 ${v.publicKey}) ${v.hostname}")
          hosts)}
      echo \'\'
    '');

  cfgsToAddHosts = filterAttrs (name: cfg: cfg.addExtraHosts) enabledCfgs;
  interfacesToAddHosts = concatLists (mapAttrsToList (name: cfg: cfg.ETHInterfaces ++ cfg.UDPInterfaces) cfgsToAddHosts);
  allExtraHosts = foldl' (acc: iface: acc // iface.connectTo) {} interfacesToAddHosts;
  extraHosts = filterAttrs (k: v: v.hostname != "") allExtraHosts;

  parseModule = x:
    (removeAttrs x [ "_module" ]) // { connectTo = mapAttrs (name: value: { inherit (value) password publicKey; }) x.connectTo; };

  # would be nice to merge 'cfg' with a //,
  # but the json nesting is wacky.
  cjdrouteConf = name: let opts = enabledCfgs.${name}; in builtins.toJSON ( {
    admin = {
      bind = opts.admin.bind;
      password = "@CJDNS_ADMIN_PASSWORD@";
    };
    authorizedPasswords = map (p: { password = p; }) opts.authorizedPasswords;
    interfaces = {
      ETHInterface = map parseModule opts.ETHInterfaces;
      UDPInterface = map parseModule opts.UDPInterfaces;
    };

    privateKey = "@CJDNS_PRIVATE_KEY@";

    resetAfterInactivitySeconds = 100;

    router = {
      interface = { type = "TUNInterface"; tunDevice = name; };
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

    services.cjdns.networks = mkOption {
      type = types.attrsOf ( types.submodule ( cjdnsSubmodule ) );
      default = { };
      example = {
        hyper = {
          ETHInterfaces = [
            {
              bind = "all";
            }
          ];
          authorizedPasswords = [ "mtQYywL0XZ6JhXm6nprvQ4XKPuS2VFYb" ];
        };
      };
      description = ''
        cjdns network encryption and routing engine configuration.

        For each defined attribute name, a TUN network interface will be created
        with the specified name. Also, a file with path <literal>/etc/cjdns-&lt;name&gt;.keys</literal>
        will be created if it does not exist to contain a random secret key that
        your IPv6 address will be derived from.

        A file with path <literal>/etc/cjdns-&lt;name&gt;.public</literal> will also
        be created, containing the IPv6 address and public key of the specified
        cjdns network.
      '';
    };

  };

  config = mkIf (enabledCfgs != []) {

    boot.kernelModules = [ "tun" ];

    # networking.firewall.allowedUDPPorts = ...

    systemd.services = mapAttrs' (name: opts:
      nameValuePair "cjdns-${name}" {
        description = "cjdns: routing engine designed for security, scalability, speed and ease of use";
        wantedBy = [ "multi-user.target" "sleep.target"];
        after = [ "network-online.target" ];
        bindsTo = [ "network-online.target" ];

        preStart = if opts.confFile != null then "" else ''
          [ -e /etc/cjdns-${name}.keys ] && source /etc/cjdns-${name}.keys

          if [ -z "$CJDNS_PRIVATE_KEY" ]; then
              shopt -s lastpipe
              ${pkg}/bin/makekeys | { read private ipv6 public; }

              umask 0077
              echo "CJDNS_PRIVATE_KEY=$private" >> /etc/cjdns-${name}.keys
              echo -e "CJDNS_IPV6=$ipv6\nCJDNS_PUBLIC_KEY=$public" > /etc/cjdns-${name}.public

              chmod 600 /etc/cjdns-${name}.keys
              chmod 444 /etc/cjdns-${name}.public
          fi

          if [ -z "$CJDNS_ADMIN_PASSWORD" ]; then
              echo "CJDNS_ADMIN_PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 96)" \
                  >> /etc/cjdns-${name}.keys
          fi
        '';

        script = (
          if opts.confFile != null then "${pkg}/bin/cjdroute < ${opts.confFile}" else
            ''
              source /etc/cjdns-${name}.keys
              echo '${cjdrouteConf name}' | sed \
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
          CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW CAP_SETUID";
          ProtectSystem = true;
          MemoryDenyWriteExecute = true;
          ProtectHome = true;
          PrivateTmp = true;
        };
      }
    ) enabledCfgs;

    networking.extraHosts = mkIf (extraHosts != {}) (cjdnsExtraHosts extraHosts);

    assertions =
      let
        mapAssertion = name: cfg:
        { assertion = (length cfg.ETHInterfaces) != 0 || (length cfg.UDPInterfaces) != 0 || cfg.confFile != null;
          message = "No cjdns.${name}.ETHInterfaces or cjdns.${name}.UDPInterfaces are defined";
        };
      in
        (mapAttrsToList (name: cfg: mapAssertion name cfg) enabledCfgs) ++ [
          { assertion =
              let admins = mapAttrsToList (name: value: value.admin.bind) enabledCfgs; in
              (length admins) == (length (unique admins));
            message = "You cannot have two cjdns networks with the same admin bind address";
          }
          { assertion = config.networking.enableIPv6;
            message = "networking.enableIPv6 must be enabled for CJDNS to work";
          }
        ];
  };
}
