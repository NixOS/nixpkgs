{ ... }:
{
  name = "stump-nixos";

  nodes.machine =
    { ... }:
    {
      services.stump.enable = true;
    };

  testScript = ''
    import json

    machine.wait_for_unit("stump.service")

    machine.wait_for_open_port(10001)
    machine.succeed("curl --fail -s http://localhost:10001/")

    machine.succeed("curl --fail -s --data '{\"username\":\"admin\",\"password\":\"admin\"}' -H 'Content-Type: application/json' -X POST http://localhost:10001/api/v2/auth/register")

    response = machine.succeed("curl --fail -s -X GET http://localhost:10001/api/v2/claim")
    is_claimed = json.loads(response)['isClaimed']

    assert is_claimed
  '';
}
