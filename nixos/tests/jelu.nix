import ./make-test-python.nix (
  { lib, ... }:
  {
    name = "jelu";
    meta.maintainers = with lib.maintainers; [ m0streng0 ];

    nodes.machine = {
      services.jelu = {
        enable = true;
        openFirewall = true;
      };
    };

    testScript = ''
      machine.start()
      machine.wait_for_unit("jelu.service")
      machine.wait_for_open_port(11111)
      machine.succeed("curl -f http://localhost:11111/")
      machine.succeed("test -f /var/lib/jelu/database/jelu.db")
    '';
  }
)
