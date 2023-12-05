{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sslh;
  user = "sslh";

  configFormat = pkgs.formats.libconfig {};
  configFile = configFormat.generate "sslh.conf" cfg.settings;
in

{
  imports = [
    (mkRenamedOptionModule [ "services" "sslh" "listenAddress" ] [ "services" "sslh" "listenAddresses" ])
    (mkRenamedOptionModule [ "services" "sslh" "timeout" ] [ "services" "sslh" "settings" "timeout" ])
    (mkRenamedOptionModule [ "services" "sslh" "transparent" ] [ "services" "sslh" "settings" "transparent" ])
    (mkRemovedOptionModule [ "services" "sslh" "appendConfig" ] "Use services.sslh.settings instead")
    (mkChangedOptionModule [ "services" "sslh" "verbose" ] [ "services" "sslh" "settings" "verbose-connections" ]
      (config: if config.services.sslh.verbose then 1 else 0))
  ];

  meta.buildDocsInSandbox = false;

  options.services.sslh = {
    enable = mkEnableOption (lib.mdDoc "sslh, protocol demultiplexer");

    method = mkOption {
      type = types.enum [ "fork" "select" "ev" ];
      default = "fork";
      description = lib.mdDoc ''
        The method to use for handling connections:

          - `fork` forks a new process for each incoming connection. It is
          well-tested and very reliable, but incurs the overhead of many
          processes.

          - `select` uses only one thread, which monitors all connections at once.
          It has lower overhead per connection, but if it stops, you'll lose all
          connections.

          - `ev` is implemented using libev, it's similar to `select` but
            scales better to a large number of connections.
      '';
    };

    listenAddresses = mkOption {
      type = with types; coercedTo str singleton (listOf str);
      default = [ "0.0.0.0" "[::]" ];
      description = lib.mdDoc "Listening addresses or hostnames.";
    };

    port = mkOption {
      type = types.port;
      default = 443;
      description = lib.mdDoc "Listening port.";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = configFormat.type;

        options.timeout = mkOption {
          type = types.ints.unsigned;
          default = 2;
          description = lib.mdDoc "Timeout in seconds.";
        };

        options.transparent = mkOption {
          type = types.bool;
          default = false;
          description = lib.mdDoc ''
            Whether the services behind sslh (Apache, sshd and so on) will see the
            external IP and ports as if the external world connected directly to
            them.
          '';
        };

        options.verbose-connections = mkOption {
          type = types.ints.between 0 4;
          default = 0;
          description = lib.mdDoc ''
            Where to log connections information. Possible values are:

             0. don't log anything
             1. write log to stdout
             2. write log to syslog
             3. write log to both stdout and syslog
             4. write to a log file ({option}`sslh.settings.logfile`)
          '';
        };

        options.numeric = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Whether to disable reverse DNS lookups, thus keeping IP
            address literals in the log.
          '';
        };

        options.protocols = mkOption {
          type = types.listOf configFormat.type;
          default = [
            { name = "ssh";     host = "localhost"; port =  "22"; service= "ssh"; }
            { name = "openvpn"; host = "localhost"; port = "1194"; }
            { name = "xmpp";    host = "localhost"; port = "5222"; }
            { name = "http";    host = "localhost"; port =   "80"; }
            { name = "tls";     host = "localhost"; port =  "443"; }
            { name = "anyprot"; host = "localhost"; port =  "443"; }
          ];
          description = lib.mdDoc ''
            List of protocols sslh will probe for and redirect.
            Each protocol entry consists of:

              - `name`: name of the probe.

              - `service`: libwrap service name (see {manpage}`hosts_access(5)`),

              - `host`, `port`: where to connect when this probe succeeds,

              - `log_level`: to log incoming connections,

              - `transparent`: proxy this protocol transparently,

              - etc.

            See the documentation for all options, including probe-specific ones.
          '';
        };
      };
      description = lib.mdDoc "sslh configuration. See {manpage}`sslh(8)` for available settings.";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      systemd.services.sslh = {
        description = "Applicative Protocol Multiplexer (e.g. share SSH and HTTPS on the same port)";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          DynamicUser          = true;
          User                 = "sslh";
          PermissionsStartOnly = true;
          Restart              = "always";
          RestartSec           = "1s";
          ExecStart            = "${pkgs.sslh}/bin/sslh-${cfg.method} -F${configFile}";
          KillMode             = "process";
          AmbientCapabilities  = ["CAP_NET_BIND_SERVICE" "CAP_NET_ADMIN" "CAP_SETGID" "CAP_SETUID"];
          PrivateTmp           = true;
          PrivateDevices       = true;
          ProtectSystem        = "full";
          ProtectHome          = true;
        };
      };

      services.sslh.settings = {
        # Settings defined here are not supposed to be changed: doing so will
        # break the module, as such you need `lib.mkForce` to override them.
        foreground = true;
        inetd = false;
        listen = map (addr: { host = addr; port = toString cfg.port; }) cfg.listenAddresses;
      };

    })

    # code from https://github.com/yrutschle/sslh#transparent-proxy-support
    # the only difference is using iptables mark 0x2 instead of 0x1 to avoid conflicts with nixos/nat module
    (mkIf (cfg.enable && cfg.settings.transparent) {
      # Set route_localnet = 1 on all interfaces so that ssl can use "localhost" as destination
      boot.kernel.sysctl."net.ipv4.conf.default.route_localnet" = 1;
      boot.kernel.sysctl."net.ipv4.conf.all.route_localnet"     = 1;

      systemd.services.sslh = let
        iptablesCommands = [
          # DROP martian packets as they would have been if route_localnet was zero
          # Note: packets not leaving the server aren't affected by this, thus sslh will still work
          { table = "raw";    command = "PREROUTING  ! -i lo -d 127.0.0.0/8 -j DROP"; }
          { table = "mangle"; command = "POSTROUTING ! -o lo -s 127.0.0.0/8 -j DROP"; }
          # Mark all connections made by ssl for special treatment (here sslh is run as user ${user})
          { table = "nat";    command = "OUTPUT -m owner --uid-owner ${user} -p tcp --tcp-flags FIN,SYN,RST,ACK SYN -j CONNMARK --set-xmark 0x02/0x0f"; }
          # Outgoing packets that should go to sslh instead have to be rerouted, so mark them accordingly (copying over the connection mark)
          { table = "mangle"; command = "OUTPUT ! -o lo -p tcp -m connmark --mark 0x02/0x0f -j CONNMARK --restore-mark --mask 0x0f"; }
        ];
        ip6tablesCommands = [
          { table = "raw";    command = "PREROUTING  ! -i lo -d ::1/128     -j DROP"; }
          { table = "mangle"; command = "POSTROUTING ! -o lo -s ::1/128     -j DROP"; }
          { table = "nat";    command = "OUTPUT -m owner --uid-owner ${user} -p tcp --tcp-flags FIN,SYN,RST,ACK SYN -j CONNMARK --set-xmark 0x02/0x0f"; }
          { table = "mangle"; command = "OUTPUT ! -o lo -p tcp -m connmark --mark 0x02/0x0f -j CONNMARK --restore-mark --mask 0x0f"; }
        ];
      in {
        path = [ pkgs.iptables pkgs.iproute2 pkgs.procps ];

        preStart = ''
          # Cleanup old iptables entries which might be still there
          ${concatMapStringsSep "\n" ({table, command}: "while iptables -w -t ${table} -D ${command} 2>/dev/null; do echo; done") iptablesCommands}
          ${concatMapStringsSep "\n" ({table, command}:       "iptables -w -t ${table} -A ${command}"                           ) iptablesCommands}

          # Configure routing for those marked packets
          ip rule  add fwmark 0x2 lookup 100
          ip route add local 0.0.0.0/0 dev lo table 100

        '' + optionalString config.networking.enableIPv6 ''
          ${concatMapStringsSep "\n" ({table, command}: "while ip6tables -w -t ${table} -D ${command} 2>/dev/null; do echo; done") ip6tablesCommands}
          ${concatMapStringsSep "\n" ({table, command}:       "ip6tables -w -t ${table} -A ${command}"                           ) ip6tablesCommands}

          ip -6 rule  add fwmark 0x2 lookup 100
          ip -6 route add local ::/0 dev lo table 100
        '';

        postStop = ''
          ${concatMapStringsSep "\n" ({table, command}: "iptables -w -t ${table} -D ${command}") iptablesCommands}

          ip rule  del fwmark 0x2 lookup 100
          ip route del local 0.0.0.0/0 dev lo table 100
        '' + optionalString config.networking.enableIPv6 ''
          ${concatMapStringsSep "\n" ({table, command}: "ip6tables -w -t ${table} -D ${command}") ip6tablesCommands}

          ip -6 rule  del fwmark 0x2 lookup 100
          ip -6 route del local ::/0 dev lo table 100
        '';
      };
    })
  ];
}
