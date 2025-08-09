{ pkgs, ... }:
{
  name = "vault-dev";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      lnl7
      mic92
    ];
  };
  nodes.machine =
    { pkgs, config, ... }:
    {
      environment.systemPackages = [ pkgs.vault ];
      environment.variables.VAULT_ADDR = "http://127.0.0.1:8200";
      environment.variables.VAULT_TOKEN = "phony-secret";

      services.vault = {
        enable = true;
        dev = true;
        devRootTokenID = config.environment.variables.VAULT_TOKEN;
      };
    };

  testScript = ''
    import json
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("vault.service")
    machine.wait_for_open_port(8200)
    out = machine.succeed("vault status -format=json")
    print(out)
    status = json.loads(out)
    assert status.get("initialized") == True
    machine.succeed("vault kv put secret/foo bar=baz")
    out = machine.succeed("vault kv get -format=json secret/foo")
    print(out)
    status = json.loads(out)
    assert status.get("data", {}).get("data", {}).get("bar") == "baz"
  '';
}
