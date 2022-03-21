import ./make-test-python.nix (
  { pkgs, ... }: {
    name = "dnsdist";
    meta = with pkgs.lib; {
      maintainers = with maintainers; [ jojosch ];
    };

    machine = { pkgs, lib, ... }: {
      services.bind = {
        enable = true;
        extraOptions = "empty-zones-enable no;";
        zones = lib.singleton {
          name = ".";
          master = true;
          file = pkgs.writeText "root.zone" ''
            $TTL 3600
            . IN SOA ns.example.org. admin.example.org. ( 1 3h 1h 1w 1d )
            . IN NS ns.example.org.

            ns.example.org. IN A    192.168.0.1
            ns.example.org. IN AAAA abcd::1

            1.0.168.192.in-addr.arpa IN PTR ns.example.org.
          '';
        };
      };
      services.dnsdist = {
        enable = true;
        listenPort = 5353;
        extraConfig = ''
          newServer({address="127.0.0.1:53", name="local-bind"})
        '';
      };

      environment.systemPackages = with pkgs; [ dig ];
    };

    testScript = ''
      machine.wait_for_unit("bind.service")
      machine.wait_for_open_port(53)
      machine.succeed("dig @127.0.0.1 +short -x 192.168.0.1 | grep -qF ns.example.org")

      machine.wait_for_unit("dnsdist.service")
      machine.wait_for_open_port(5353)
      machine.succeed("dig @127.0.0.1 -p 5353 +short -x 192.168.0.1 | grep -qF ns.example.org")
    '';
  }
)
