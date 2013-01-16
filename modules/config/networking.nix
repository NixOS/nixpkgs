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

    networking.dnsSingleRequest = pkgs.lib.mkOption {
      default = false;
      description = ''
        Recent versions of glibc will issue both ipv4 (A) and ipv6 (AAAA)
        address queries at the same time, from the same port. Sometimes upstream
        routers will systemically drop the ipv4 queries. The symptom of this problem is
        that 'getent hosts example.com' only returns ipv6 (or perhaps only ipv4) addresses. The
        workaround for this is to specify the option 'single-request' in
        /etc/resolve.conf. This option enables that. 
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
            ${optionalString cfg.enableIPv6 ''
              ::1 localhost
            ''}
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
            libc_restart='${pkgs.systemd}/bin/systemctl reload --no-block nscd.service'
          '' + optionalString cfg.dnsSingleRequest ''
            # only send one DNS request at a time
            resolv_conf_options='single-request'
          '' + optionalString config.services.bind.enable ''
            # This hosts runs a full-blown DNS resolver.
            name_servers='127.0.0.1'
          '' );
        target = "resolvconf.conf";
      }
    ];

  systemd.units."ip-up.target".text =
    ''
      [Unit]
      Description=Services Requiring IP Connectivity
    '';
}
