# /etc files related to networking, such as /etc/services.

{config, pkgs, ...}:

with pkgs.lib;
let
  cfg = config.networking;

  options = {

    networking.extraHosts = pkgs.lib.mkOption {
      default = "";
      example = "192.168.0.1 lanlocalhost";
      description = ''
        Additional entries to be appended to <filename>/etc/hosts</filename>.
      '';
    };

  };

in

{
  require = [options];

  environment.etc =
    [ { # /etc/services: TCP/UDP port assignments.
        source = pkgs.iana_etc + "/etc/services";
        target = "services";
      }

      { # /etc/protocols: IP protocol numbers.
        source = pkgs.iana_etc + "/etc/protocols";
        target = "protocols";
      }

      { # /etc/rpc: RPC program numbers.
        source = pkgs.glibc + "/etc/rpc";
        target = "rpc";
      }

      { # /etc/hosts: Hostname-to-IP mappings.
        source = pkgs.writeText "hosts"
          ''
            127.0.0.1 localhost
            ::1 localhost
            ${cfg.extraHosts}
          '';
        target = "hosts";
      }

      { # /etc/resolvconf.conf: Configuration for openresolv.
        source = pkgs.writeText "resolvconf.conf" (
          ''
            # This is the default, but we must set it here to prevent
            # a collision with an apparently unrelated environment
            # variable with the same name exported by dhcpcd.
            interface_order='lo lo[0-9]*'
          '' + optionalString config.services.nscd.enable ''
            # Invalidate the nscd cache whenever resolv.conf is
            # regenerated.
            libc_restart='${pkgs.upstart}/sbin/start invalidate-nscd'
          '' + optionalString config.services.bind.enable ''
            # This hosts runs a full-blown DNS resolver.
            name_servers='127.0.0.1'
          '' );
        target = "resolvconf.conf";
      }
    ];
}
