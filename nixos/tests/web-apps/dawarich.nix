{ ... }:
{
  name = "dawarich-nixos";

  nodes.machine =
    { pkgs, ... }:
    {
      services.dawarich = {
        enable = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("dawarich.target")

    machine.wait_for_open_port(3000) # Web
    machine.succeed("curl --fail http://localhost:3000/")
  '';
}
