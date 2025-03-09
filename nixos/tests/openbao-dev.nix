{ pkgs, ... }:
{
  name = "openbao-dev";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      brianmay
    ];
  };
  nodes.machine =
    { pkgs, config, ... }:
    {
      environment.variables.VAULT_ADDR = "http://127.0.0.1:8200";
      environment.variables.VAULT_TOKEN = "phony-secret";

      services.openbao = {
        enable = true;
        dev = true;
        devRootTokenID = config.environment.variables.VAULT_TOKEN;
      };
    };

  testScript = ''
    import json
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("openbao.service")
    machine.wait_for_open_port(8200)
    out = machine.succeed("bao status -format=json")
    print(out)
    status = json.loads(out)
    assert status.get("initialized") == True
    machine.succeed("bao kv put secret/foo bar=baz")
    out = machine.succeed("bao kv get -format=json secret/foo")
    print(out)
    status = json.loads(out)
    assert status.get("data", {}).get("data", {}).get("bar") == "baz"
  '';
}
