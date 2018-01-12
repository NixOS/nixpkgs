import ./make-test.nix ({ pkgs, ... }:
{
  name = "vault";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lnl7 ];
  };
  machine = { config, pkgs, ... }: {
    environment.systemPackages = [ pkgs.vault ];
    environment.variables.VAULT_ADDR = "http://127.0.0.1:8200";
    services.vault.enable = true;
  };

  testScript =
    ''
      startAll;

      $machine->waitForUnit('multi-user.target');
      $machine->waitForUnit('vault.service');
      $machine->waitForOpenPort(8200);
      $machine->succeed('vault init');
      $machine->succeed('vault status | grep "Sealed: true"');
    '';
})
