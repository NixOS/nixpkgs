{
  config,
  lib,
  pkgs,
  ...
}:
let
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
in
{
  name = "bind";

  nodes = {
    machine = {
      services.bind = {
        enable = true;

        extraOptions = "empty-zones-enable no;";
        inherit zones;
      };
    };

    machineNonDefaultPortt = {
      services.bind = {
        enable = true;

        extraOptions = "empty-zones-enable no;";
        inherit zones;

        listenOnPort = 9053;
      };
    };
  };

  testScript = ''
    with subtest("Bind starts and responds"):
      machine.wait_for_unit("bind.service")
      machine.succeed("host 192.168.0.1 127.0.0.1 | grep -qF ns.example.org")

    with subtest("Bind start and responds none default port"):
      machineNoneDefaultPort.wait_for_unit("bind.service")
      machineNoneDefaultPort.succeed("host -p 9053 192.168.0.1 127.0.0.1 | grep -qF ns.example.org")
  '';
}
