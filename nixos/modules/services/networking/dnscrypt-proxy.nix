{ config, lib, pkgs, ... }:
with lib;

let
  apparmorEnabled = config.security.apparmor.enable;
  dnscrypt-proxy = pkgs.dnscrypt-proxy;
  cfg = config.services.dnscrypt-proxy;
  uid = config.ids.uids.dnscrypt-proxy;
  daemonArgs =
    [ "--daemonize"
      "--user=dnscrypt-proxy"
      "--local-address=${cfg.localAddress}:${toString cfg.port}"
      (optionalString cfg.tcpOnly "--tcp-only")
      "--resolvers-list=${dnscrypt-proxy}/share/dnscrypt-proxy/dnscrypt-resolvers.csv"
      "--resolver-name=${cfg.resolverName}"
    ];
in

{
  ##### interface

  options = {

    services.dnscrypt-proxy = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable dnscrypt-proxy.
          The proxy relays regular DNS queries to a DNSCrypt enabled
          upstream resolver.
          The traffic between the client and the upstream resolver is
          encrypted and authenticated, which may mitigate the risk of MITM
          attacks and third-party snooping (assuming the upstream is
          trustworthy).
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
          The name of the upstream DNSCrypt resolver to use.
          See <literal>${dnscrypt-proxy}/share/dnscrypt-proxy/dnscrypt-resolvers.csv</literal>
          for alternative resolvers (e.g., if you are concerned about logging
          and/or server location).
        '';
      };

      tcpOnly = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Force sending encrypted DNS queries to the upstream resolver
          over TCP instead of UDP (on port 443).
          Enabling this option may help circumvent filtering, but should
          not be used otherwise.
        '';
      };

    };

  };

  ##### implementation

  config = mkIf cfg.enable {

    ### AppArmor profile

    security.apparmor.profiles = mkIf apparmorEnabled [
      (pkgs.writeText "apparmor-dnscrypt-proxy" ''

        ${dnscrypt-proxy}/sbin/dnscrypt-proxy {
          capability ipc_lock,
          capability net_bind_service,
          capability net_admin,
          capability sys_chroot,
          capability setgid,
          capability setuid,

          /dev/null rw,
          /dev/urandom r,

          ${pkgs.glibc}/lib/*.so mr,
          ${pkgs.tzdata}/share/zoneinfo/** r,

          ${dnscrypt-proxy}/share/dnscrypt-proxy/** r,
          ${pkgs.gcc.gcc}/lib/libssp.so.* mr,
          ${pkgs.libsodium}/lib/libsodium.so.* mr,
        }
      '')
    ];

    ### User

    users.extraUsers = singleton {
      inherit uid;
      name = "dnscrypt-proxy";
      description = "dnscrypt-proxy daemon user";
    };

    ### Service definition

    systemd.services.dnscrypt-proxy = {
      description = "dnscrypt-proxy daemon";
      after = [ "network.target" ] ++ optional apparmorEnabled "apparmor.service";
      requires = mkIf apparmorEnabled [ "apparmor.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${dnscrypt-proxy}/sbin/dnscrypt-proxy ${toString daemonArgs}";
      };
    };

  };
}
