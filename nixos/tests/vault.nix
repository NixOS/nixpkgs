import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "vault";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ lnl7 ];
  };
  nodes.machine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.vault ];
    environment.variables.VAULT_ADDR = "http://127.0.0.1:8200";
    services.vault.enable = true;
  };

  testScript =
    ''
      start_all()

      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("vault.service")
      machine.wait_for_open_port(8200)
      machine.succeed("vault operator init")
      # vault now returns exit code 2 for sealed vaults
      machine.fail("vault status")
      machine.succeed("vault status || test $? -eq 2")
    '';
})
