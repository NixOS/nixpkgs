{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sslh;
  user = "sslh";
  configFile = pkgs.writeText "sslh.conf" ''
    verbose: ${boolToString cfg.verbose};
    foreground: true;
    inetd: false;
    numeric: false;
    transparent: ${boolToString cfg.transparent};
    timeout: "${toString cfg.timeout}";

    listen:
    (
      ${
        concatMapStringsSep ",\n"
        (addr: ''{ host: "${addr}"; port: "${toString cfg.port}"; }'')
        cfg.listenAddresses
      }
    );

    ${cfg.appendConfig}
  '';
  defaultAppendConfig = ''
    protocols:
    (
      { name: "ssh"; service: "ssh"; host: "localhost"; port: "22"; probe: "builtin"; },
      { name: "openvpn"; host: "localhost"; port: "1194"; probe: "builtin"; },
      { name: "xmpp"; host: "localhost"; port: "5222"; probe: "builtin"; },
      { name: "http"; host: "localhost"; port: "80"; probe: "builtin"; },
      { name: "tls"; host: "localhost"; port: "443"; probe: "builtin"; },
      { name: "anyprot"; host: "localhost"; port: "443"; probe: "builtin"; }
    );
  '';
in
{
  imports = [
    (mkRenamedOptionModule [ "services" "sslh" "listenAddress" ] [ "services" "sslh" "listenAddresses" ])
  ];

  options = {
    services.sslh = {
      enable = mkEnableOption (lib.mdDoc "sslh");

      verbose = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Verbose logs.";
      };

      timeout = mkOption {
        type = types.int;
        default = 2;
        description = lib.mdDoc "Timeout in seconds.";
      };

      transparent = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Will the services behind sslh (Apache, sshd and so on) see the external IP and ports as if the external world connected directly to them";
      };

      listenAddresses = mkOption {
        type = types.coercedTo types.str singleton (types.listOf types.str);
        default = [ "0.0.0.0" "[::]" ];
        description = lib.mdDoc "Listening addresses or hostnames.";
      };

      port = mkOption {
        type = types.int;
        default = 443;
        description = lib.mdDoc "Listening port.";
      };

      appendConfig = mkOption {
        type = types.str;
        default = defaultAppendConfig;
        description = lib.mdDoc "Verbatim configuration file.";
      };
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
          ExecStart            = "${pkgs.sslh}/bin/sslh -F${configFile}";
          KillMode             = "process";
          AmbientCapabilities  = "CAP_NET_BIND_SERVICE CAP_NET_ADMIN CAP_SETGID CAP_SETUID";
          PrivateTmp           = true;
          PrivateDevices       = true;
          ProtectSystem        = "full";
          ProtectHome          = true;
        };
      };
    })

    # code from https://github.com/yrutschle/sslh#transparent-proxy-support
    # the only difference is using iptables mark 0x2 instead of 0x1 to avoid conflicts with nixos/nat module
    (mkIf (cfg.enable && cfg.transparent) {
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
