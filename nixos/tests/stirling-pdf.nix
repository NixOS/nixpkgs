import ./make-test-python.nix (
  { lib, ... }:

  {
    name = "stirling-pdf";
    meta.maintainers = with lib.maintainers; [ thubrecht ];

    nodes.machine = {
      services.stirling-pdf = {
        enable = true;
        port = 3000;
      };
    };

    testScript = ''
      machine.start()
      machine.wait_for_unit("stirling-pdf.service")
      machine.wait_for_open_port(3000)
      machine.succeed("curl --fail http://localhost:3000/")
    '';
  }
)
