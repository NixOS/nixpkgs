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
      enable = mkEnableOption ''
        Enable dnscrypt-proxy. The proxy relays regular DNS queries to a
        DNSCrypt enabled upstream resolver. The traffic between the
        client and the upstream resolver is encrypted and authenticated,
        which may mitigate the risk of MITM attacks and third-party
        snooping (assuming the upstream is trustworthy).
      '';
      localAddress = mkOption {
        default = "127.0.0.1";
        type = types.string;
        description = ''
          Listen for DNS queries on this address.
        '';
      };
      localPort = mkOption {
        default = 53;
        type = types.int;
        description = ''
          Listen on this port.
        '';
      };
      resolverName = mkOption {
        default = "cisco";
        type = types.nullOr types.string;
        description = ''
          The name of the upstream DNSCrypt resolver to use. See
          <literal>${resolverListFile}</literal> for alternative resolvers
          (e.g., if you are concerned about logging and/or server
          location).
        '';
      };
      customResolver = mkOption {
        default = null;
        description = ''
          Use a resolver not listed in the upstream list (e.g.,
          a private DNSCrypt provider). For advanced users only.
          If specified, this option takes precedence.
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
         }; }; }));
      };
      tcpOnly = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Force sending encrypted DNS queries to the upstream resolver
          over TCP instead of UDP (on port 443). Enabling this option may
          help circumvent filtering, but should not be used otherwise.
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

        ${pkgs.glibc}/lib/*.so mr,
        ${pkgs.tzdata}/share/zoneinfo/** r,

        network inet stream,
        network inet6 stream,
        network inet dgram,
        network inet6 dgram,

        ${pkgs.gcc.cc}/lib/libssp.so.* mr,
        ${pkgs.libsodium}/lib/libsodium.so.* mr,
        ${pkgs.systemd}/lib/libsystemd.so.* mr,
        ${pkgs.xz}/lib/liblzma.so.* mr,
        ${pkgs.libgcrypt}/lib/libgcrypt.so.* mr,
        ${pkgs.libgpgerror}/lib/libgpg-error.so.* mr,

        ${resolverListFile} r,
      }
    ''));

    users.extraUsers.dnscrypt-proxy = {
      uid = config.ids.uids.dnscrypt-proxy;
      description = "dnscrypt-proxy daemon user";
    };
    users.extraGroups.dnscrypt-proxy.gid = config.ids.gids.dnscrypt-proxy;

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
      };
    };
  };
}
