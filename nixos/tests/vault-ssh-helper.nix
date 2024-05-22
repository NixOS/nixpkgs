import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "vault-ssh-helper";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ lpostula ];
  };
  nodes.machine = { pkgs, config, ... }: {
    environment.systemPackages = [ pkgs.vault pkgs.vault-ssh-helper ];
    environment.variables.VAULT_ADDR = "http://127.0.0.1:8200";
    environment.variables.VAULT_TOKEN = "phony-secret";

    services.vault = {
      enable = true;
      dev = true;
      devRootTokenID = config.environment.variables.VAULT_TOKEN;
    };
  };

  testScript = let
    config = pkgs.writeText "config.hcl" ''
      vault_addr = "http://127.0.0.1:8200"
      tls_skip_verify = false
      ssh_mount_point = "ssh"
      allowed_roles = "*"
    '';
  in ''
    import json
    start_all()
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("vault.service")
    machine.wait_for_open_port(8200)
    out = machine.succeed("vault status -format=json")
    status = json.loads(out)
    assert status.get("initialized") == True
    machine.succeed("vault secrets enable ssh")
    machine.succeed("vault-ssh-helper -dev -verify-only -config=${config}")
  '';
})
