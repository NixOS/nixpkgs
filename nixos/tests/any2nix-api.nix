{ lib, ... }:
let
  port = 3000;
in
{
  name = "any2nix-api";
  meta.maintainers = with lib.maintainers; [
    gbr-ufs
  ];
  nodes.machine =
    { ... }:
    {
      services.any2nix-api = {
        enable = true;
        address = "127.0.0.1";
        inherit port;
      };
    };
  testScript = ''
    machine.wait_for_unit("any2nix-api.service")
    machine.wait_for_open_port(${toString port})
    # Test root endpoint.
    response = machine.succeed("curl -fsS http://127.0.0.1:${toString port}/")
    assert "any2nix-api" in response
    # Test conversion endpoint.
    conversion = machine.succeed(
        'curl -fsS -X POST -H "Content-Type: application/json" -d \'{"input": "[package]\\nname = \\"any2nix\\""}\' http://127.0.0.1:${toString port}/v1/toml'
    )
    assert "any2nix" in conversion
  '';
}
