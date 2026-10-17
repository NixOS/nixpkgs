{ lib, ... }:
let
  port = 3000;
in
{
  name = "any2nix-website";
  meta.maintainers = with lib.maintainers; [
    gbr-ufs
  ];
  nodes.machine =
    { ... }:
    {
      services.any2nix-website = {
        enable = true;
        address = "127.0.0.1";
        inherit port;
      };
    };
  testScript = ''
    machine.wait_for_unit("any2nix-website.service")
    machine.wait_for_open_port(${toString port})
    # Test root HTML page.
    response = machine.succeed("curl -fsS http://127.0.0.1:${toString port}/")
    assert "<title>any2nix</title>" in response
    # Test static assets.
    machine.succeed("curl -fsS http://127.0.0.1:${toString port}/assets/index.css")
    machine.succeed("curl -fsS http://127.0.0.1:${toString port}/assets/index.js")
  '';
}
