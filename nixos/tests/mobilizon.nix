import ./make-test-python.nix ({ lib, ...}:

{
  name = "mobilizon";
  meta.maintainers = with lib.maintainers; [ minijackson ];

  machine =
    { ... }:
    {
      services.mobilizon = {
        enable = true;
        settings.":mobilizon".":instance" = {
          name = "Test Mobilizon";
          hostname = "localhost";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("mobilizon.service")
    machine.wait_for_open_port(4000)
    machine.succeed("curl --fail http://localhost:4000/")
  '';
})
