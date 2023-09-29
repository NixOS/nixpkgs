import ./make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "stash";
  meta.maintainers = with maintainers; [ halfdrie ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.stash = {
        enable = true;
        port = 1234;
      };
    };

  testScript = ''
    machine.wait_for_unit("stash.service")
    machine.wait_for_open_port(1234)
    machine.succeed("curl --fail http://localhost:1234/")
  '';
})
