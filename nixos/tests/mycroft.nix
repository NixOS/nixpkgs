import ./make-test-python.nix ({ pkgs, lib, ... }:

with lib;

{
  name = "mycroft";
  meta.maintainers = teams.mycroft.members;

  machine = { pkgs, ... }:
  {
    services.mycroft = {
      enable = true;
      settings = {};
    };
  };

  testScript = ''
    machine.wait_for_unit("mycroft.target")

    machine.wait_for_open_port(18181)
    machine.succeed("curl --fail http://localhost:18181/gui")
  '';
})
