import ./make-test-python.nix ({ pkgs, lib, ... }:
let
  zoneTmpl = addr: lib.singleton {
    name = ".";
    master = true;
    file = pkgs.writeText "root.zone" ''
      $TTL 3600
      . IN SOA ns.example.org. admin.example.org. ( 1 3h 1h 1w 1d )
      . IN NS ns.example.org.

      ns.example.org. IN A    192.168.0.${addr}
      ns.example.org. IN AAAA abcd::${addr}

      ${addr}.0.168.192.in-addr.arpa IN PTR ns.example.org.
    '';
  };
in
{
  name = "bind";

  nodes.machine = { ... }: {
    services.bind.enable = true;
    services.bind.extraOptions = "empty-zones-enable no;";
    services.bind.zones = zoneTmpl "1";

    specialisation.daemonReload.configuration = {
      services.bind.zones = lib.mkForce (zoneTmpl "2");
    };

  };

  testScript = { nodes, ... }:
    ''
      machine.wait_for_unit("bind.service")
      machine.wait_for_open_port(53)
      machine.succeed("host 192.168.0.1 127.0.0.1 | grep -qF ns.example.org")
      machine.succeed("${nodes.machine.system.build.toplevel}/specialisation/daemonReload/bin/switch-to-configuration test >&2")
      machine.succeed("host 192.168.0.2 127.0.0.1 | grep -qF ns.example.org")
    '';
})
