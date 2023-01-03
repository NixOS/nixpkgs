import ./make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "uptime-kuma";
  meta.maintainers = with maintainers; [ julienmalka ];

  nodes.machine =
    { pkgs, ... }:
    { services.uptime-kuma.enable = true; };

  testScript = ''
    machine.start()
    machine.wait_for_unit("uptime-kuma.service")
    machine.wait_for_open_port(3001)
    machine.succeed("curl --fail http://localhost:3001/")
  '';
})
