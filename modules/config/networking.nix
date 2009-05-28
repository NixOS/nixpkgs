# /etc files related to networking, such as /etc/services.

{config, pkgs, ...}:

let

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
            ${config.networking.extraHosts}
            127.0.0.1 localhost
          '';
        target = "hosts";
      }
    ];
}
