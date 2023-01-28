import ./make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "ombi";
  meta.maintainers = with maintainers; [ woky ];

  nodes.machine =
    { pkgs, ... }:
    { services.ombi.enable = true; };

  testScript = ''
    machine.wait_for_unit("ombi.service")
    machine.wait_for_open_port(5000)
    machine.succeed("curl --fail http://localhost:5000/")
  '';
})
