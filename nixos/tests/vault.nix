import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "vault";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lnl7 ];
  };
  machine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.vault ];
    environment.variables.VAULT_ADDR = "http://127.0.0.1:8200";
    services.vault.enable = true;
    virtualisation.memorySize = 512;
  };

  testScript =
    ''
      start_all()

      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("vault.service")
      machine.wait_for_open_port(8200)
      machine.succeed("vault operator init")
      machine.succeed("vault status | grep Sealed | grep true")
    '';
})
