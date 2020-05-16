import ./make-test-python.nix {
  name = "bind";

  machine = { pkgs, lib, ... }: {
    services.bind.enable = true;
    services.bind.extraOptions = "empty-zones-enable no;";
    services.bind.zones = {
      "." = {
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
      # "fail-with-assert" = {};
      "minimal" = {
        name = "minimal";
        file = {
          records = [
            { name = "ns"; value = "192.168.1.1"; }
          ];
        };
      };
      "common" = {
        file = {
          serial = 12;
          records = [
            { name = "ns"; value = "192.168.1.1"; }
            { name = "webserver"; value = "192.168.1.1"; }
          ];
        };
      };
      "maxconf" = {
        file = {
          serial = 1;
          refresh = "3H";
          retry = "1H";
          expire = "1W";
          minimum_ttl = "1D";
          name_primary = "ns1";
          records = [
            { name = "ns1"; value = "192.168.1.1"; }
            { name = "ns"; value = "192.168.1.1"; type = "A"; ttl = "3H"; }
          ];
        };
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("bind.service")
    machine.wait_for_open_port(53)
    machine.succeed("host 192.168.0.1 127.0.0.1")

    machine.succeed("host ns.example.org 127.0.0.1")
    machine.fail("host notfound.example.org 127.0.0.1")

    machine.succeed("host ns.common 127.0.0.1")
    machine.succeed("host webserver.common 127.0.0.1")
    machine.fail("host notfound.common 127.0.0.1")

    machine.succeed("host ns.maxconf 127.0.0.1")

    machine.succeed("host webserver.common 127.0.0.1")
  '';
}
