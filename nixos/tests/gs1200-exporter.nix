import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "gs1200-exporter";

    meta.maintainers = with lib.maintainers; [ DerGrumpf ];

    nodes.machine =
      { ... }:
      {
        services.gs1200-exporter = {
          enable = true;
          address = "192.168.2.4";
          password = "testpassword";
        };
      };

    testScript = ''
      machine.wait_for_unit("gs1200-exporter.service")
      machine.wait_for_open_port(9934)
      machine.succeed("curl -f http://localhost:9934/metrics")
    '';
  }
)
