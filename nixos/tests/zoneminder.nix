import ./make-test-python.nix ({ lib, ...}:

{
  name = "zoneminder";
  meta.maintainers = with lib.maintainers; [ danielfullmer ];

  nodes.machine = { ... }:
  {
    services.zoneminder = {
      enable = true;
      database.createLocally = true;
      database.username = "zoneminder";
    };
    time.timeZone = "America/New_York";
  };

  testScript = ''
    machine.wait_for_unit("zoneminder.service")
    machine.wait_for_unit("nginx.service")
    machine.wait_for_open_port(8095)
    machine.succeed("curl --fail http://localhost:8095/")
  '';
})
