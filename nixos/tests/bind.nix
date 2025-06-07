{ config, ... }:
{
  name = "bind";

  nodes.machine =
    { pkgs, lib, ... }:
    {
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

      specialisation.disabledIPv6 = {
        inheritParentConfig = true;
        configuration.networking.enableIPv6 = false;
      };
    };

  testScript = ''
    def verify_bind():
      machine.wait_for_unit("bind.service")
      machine.succeed("host 192.168.0.1 127.0.0.1 | grep -qF ns.example.org")

    with subtest("Bind starts and responds"):
      verify_bind()

    with subtest("Bind start and responds when ipv6 is disabled"):
      machine.succeed("${config.nodes.machine.system.build.toplevel}/specialisation/disabledIPv6/bin/switch-to-configuration test")
      verify_bind()
  '';
}
