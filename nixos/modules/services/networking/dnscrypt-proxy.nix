{ config, lib, pkgs, ... }:
with lib;

let
  apparmorEnabled = config.security.apparmor.enable;
  dnscrypt-proxy = pkgs.dnscrypt-proxy;
  cfg = config.services.dnscrypt-proxy;

  resolverListFile = "${dnscrypt-proxy}/share/dnscrypt-proxy/dnscrypt-resolvers.csv";
  localAddress = "${cfg.localAddress}:${toString cfg.localPort}";

  daemonArgs =
    [ "--local-address=${localAddress}"
      (optionalString cfg.tcpOnly "--tcp-only")
      (optionalString cfg.ephemeralKeys "-E")
    ]
    ++ resolverArgs;

  resolverArgs = if (cfg.customResolver != null)
    then
      [ "--resolver-address=${cfg.customResolver.address}:${toString cfg.customResolver.port}"
        "--provider-name=${cfg.customResolver.name}"
        "--provider-key=${cfg.customResolver.key}"
      ]
    else
      [ "--resolvers-list=${resolverListFile}"
        "--resolver-name=${toString cfg.resolverName}"
      ];
in

{
  options = {
    services.dnscrypt-proxy = {
      enable = mkEnableOption "dnscrypt-proxy" // { description = ''
        Whether to enable the DNSCrypt client proxy. The proxy relays
        DNS queries to a DNSCrypt enabled upstream resolver. The traffic
        between the client and the upstream resolver is encrypted and
        authenticated, mitigating the risk of MITM attacks and third-party
        snooping (assuming the upstream is trustworthy).

        Enabling this option does not alter the system nameserver; to relay
        local queries, prepend <literal>127.0.0.1</literal> to
        <option>networking.nameservers</option>.

        The recommended configuration is to run DNSCrypt proxy as a forwarder
        for a caching DNS client, as in
        <programlisting>
        {
          services.dnscrypt-proxy.enable = true;
          services.dnscrypt-proxy.localPort = 43;
          services.dnsmasq.enable = true;
          services.dnsmasq.servers = [ "127.0.0.1#43" ];
          services.dnsmasq.resolveLocalQueries = true; # this is the default
        }
        </programlisting>
      ''; };
      localAddress = mkOption {
        default = "127.0.0.1";
        type = types.string;
        description = ''
          Listen for DNS queries to relay on this address. The only reason to
          change this from its default value is to proxy queries on behalf
          of other machines (typically on the local network).
        '';
      };
      localPort = mkOption {
        default = 53;
        type = types.int;
        description = ''
          Listen for DNS queries to relay on this port. The default value
          assumes that the DNSCrypt proxy should relay DNS queries directly.
          When running as a forwarder for another DNS client, set this option
          to a different value; otherwise leave the default.
        '';
      };
      resolverName = mkOption {
        default = "dnscrypt.eu-nl";
        type = types.nullOr types.string;
        description = ''
          The name of the upstream DNSCrypt resolver to use. See
          <filename>${resolverListFile}</filename> for alternative resolvers.
          The default resolver is located in Holland, supports DNS security
          extensions, and claims to not keep logs.
        '';
      };
      customResolver = mkOption {
        default = null;
        description = ''
          Use an unlisted resolver (e.g., a private DNSCrypt provider). For
          advanced users only. If specified, this option takes precedence.
        '';
        type = types.nullOr (types.submodule ({ ... }: { options = {
          address = mkOption {
            type = types.str;
            description = "Resolver IP address";
            example = "208.67.220.220";
          };
          port = mkOption {
            type = types.int;
            description = "Resolver port";
            default = 443;
          };
          name = mkOption {
            type = types.str;
            description = "Provider fully qualified domain name";
            example = "2.dnscrypt-cert.opendns.com";
          };
          key = mkOption {
            type = types.str;
            description = "Provider public key";
            example = "B735:1140:206F:225D:3E2B:D822:D7FD:691E:A1C3:3CC8:D666:8D0C:BE04:BFAB:CA43:FB79";
          };
        }; }));
      };
      tcpOnly = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Force sending encrypted DNS queries to the upstream resolver over
          TCP instead of UDP (on port 443). Use only if the UDP port is blocked.
        '';
      };
      ephemeralKeys = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Compute a new key pair for every query.  Enabling this option
          increases CPU usage, but makes it more difficult for the upstream
          resolver to track your usage of their service across IP addresses.
          The default is to re-use the public key pair for all queries, making
          tracking trivial.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = (cfg.customResolver != null) || (cfg.resolverName != null);
        message   = "please configure upstream DNSCrypt resolver";
      }
    ];

    security.apparmor.profiles = mkIf apparmorEnabled (singleton (pkgs.writeText "apparmor-dnscrypt-proxy" ''
      ${dnscrypt-proxy}/bin/dnscrypt-proxy {
        /dev/null rw,
        /dev/urandom r,

        /etc/passwd r,
        /etc/group r,
        ${config.environment.etc."nsswitch.conf".source} r,

        ${pkgs.glibc.out}/lib/*.so mr,
        ${pkgs.tzdata}/share/zoneinfo/** r,

        network inet stream,
        network inet6 stream,
        network inet dgram,
        network inet6 dgram,

        ${pkgs.gcc.cc.lib}/lib/libssp.so.* mr,
        ${pkgs.libsodium.out}/lib/libsodium.so.* mr,
        ${pkgs.systemd}/lib/libsystemd.so.* mr,
        ${pkgs.xz.out}/lib/liblzma.so.* mr,
        ${pkgs.libgcrypt.out}/lib/libgcrypt.so.* mr,
        ${pkgs.libgpgerror.out}/lib/libgpg-error.so.* mr,
        ${pkgs.libcap.lib}/lib/libcap.so.* mr,
        ${pkgs.lz4}/lib/liblz4.so.* mr,
        ${pkgs.attr.out}/lib/libattr.so.* mr,

        ${resolverListFile} r,
      }
    ''));

    users.users.dnscrypt-proxy = {
      description = "dnscrypt-proxy daemon user";
      isSystemUser = true;
      group = "dnscrypt-proxy";
    };
    users.groups.dnscrypt-proxy = {};

    systemd.sockets.dnscrypt-proxy = {
      description = "dnscrypt-proxy listening socket";
      socketConfig = {
        ListenStream = "${localAddress}";
        ListenDatagram = "${localAddress}";
      };
      wantedBy = [ "sockets.target" ];
    };

    systemd.services.dnscrypt-proxy = {
      description = "dnscrypt-proxy daemon";

      after = [ "network.target" ] ++ optional apparmorEnabled "apparmor.service";
      requires = [ "dnscrypt-proxy.socket "] ++ optional apparmorEnabled "apparmor.service";

      serviceConfig = {
        Type = "simple";
        NonBlocking = "true";
        ExecStart = "${dnscrypt-proxy}/bin/dnscrypt-proxy ${toString daemonArgs}";

        User = "dnscrypt-proxy";
        Group = "dnscrypt-proxy";

        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
      };
    };
  };
}
