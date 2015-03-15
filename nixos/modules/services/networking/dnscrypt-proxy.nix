{ config, lib, pkgs, ... }:
with lib;

let
  apparmorEnabled = config.security.apparmor.enable;
  dnscrypt-proxy = pkgs.dnscrypt-proxy;
  cfg = config.services.dnscrypt-proxy;
  resolverListFile = "${dnscrypt-proxy}/share/dnscrypt-proxy/dnscrypt-resolvers.csv";
  daemonArgs =
    [ "--local-address=${cfg.localAddress}:${toString cfg.port}"
      (optionalString cfg.tcpOnly "--tcp-only")
      "--resolvers-list=${resolverListFile}"
      "--resolver-name=${cfg.resolverName}"
    ];
in

{
  options = {
    services.dnscrypt-proxy = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable dnscrypt-proxy. The proxy relays regular DNS queries to a
          DNSCrypt enabled upstream resolver. The traffic between the
          client and the upstream resolver is encrypted and authenticated,
          which may mitigate the risk of MITM attacks and third-party
          snooping (assuming the upstream is trustworthy).
        '';
      };
      localAddress = mkOption {
        default = "127.0.0.1";
        type = types.string;
        description = ''
          Listen for DNS queries on this address.
        '';
      };
      port = mkOption {
        default = 53;
        type = types.int;
        description = ''
          Listen on this port.
        '';
      };
      resolverName = mkOption {
        default = "opendns";
        type = types.string;
        description = ''
          The name of the upstream DNSCrypt resolver to use. See
          <literal>${resolverListFile}</literal> for alternative resolvers
          (e.g., if you are concerned about logging and/or server
          location).
        '';
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
        ListenStream = "${cfg.localAddress}:${toString cfg.port}";
        ListenDatagram = "${cfg.localAddress}:${toString cfg.port}";
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
