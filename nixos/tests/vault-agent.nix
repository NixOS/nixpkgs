import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "vault-agent";

    nodes.machine =
      { config, pkgs, ... }:
      {
        services.vault-agent.instances.example.settings = {
          vault.address = config.environment.variables.VAULT_ADDR;

          auto_auth = [
            {
              method = [
                {
                  type = "token_file";
                  config.token_file_path = pkgs.writeText "vault-token" config.environment.variables.VAULT_TOKEN;
                }
              ];
            }
          ];

          template = [
            {
              contents = ''
                {{- with secret "secret/example" }}
                {{ .Data.data.key }}"
                {{- end }}
              '';
              perms = "0600";
              destination = "/example";
            }
          ];
        };

        services.vault = {
          enable = true;
          dev = true;
          devRootTokenID = config.environment.variables.VAULT_TOKEN;
        };

        environment = {
          systemPackages = [ pkgs.vault ];
          variables = {
            VAULT_ADDR = "http://localhost:8200";
            VAULT_TOKEN = "root";
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("vault.service")
      machine.wait_for_open_port(8200)

      machine.wait_until_succeeds('vault kv put secret/example key=example')

      machine.wait_for_unit("vault-agent-example.service")

      machine.wait_for_file("/example")
      machine.succeed('grep "example" /example')
    '';
  }
)
