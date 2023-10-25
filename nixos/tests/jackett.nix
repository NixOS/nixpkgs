import ./make-test-python.nix ({ lib, ... }:

{
  name = "jackett";
  meta.maintainers = with lib.maintainers; [ etu ];

  nodes.machine =
    { pkgs, ... }:
    { services.jackett.enable = true; };

  testScript = ''
    machine.start()
    machine.wait_for_unit("jackett.service")
    machine.wait_for_open_port(9117)
    machine.succeed("curl --fail http://localhost:9117/")
  '';
})
