{ lib, ... }:
{
  name = "openbao-agent";

  meta.maintainers = with lib.maintainers; [ kiara ];

  nodes.machine =
    { config, pkgs, ... }:
    {
      services.openbao-agent.instances.example.settings = {
        vault.address = config.environment.variables.BAO_ADDR;

        auto_auth.method = [
          {
            type = "token_file";
            config.token_file_path = pkgs.writeText "bao-token" config.environment.variables.BAO_TOKEN;
          }
        ];

        template = [
          {
            contents = ''
              {{- with secret "secret/example" }}
              {{ .Data.data.key }}
              {{- end }}
            '';
            perms = "0600";
            destination = "/example";
          }
        ];
      };

      # skip init/unseal - `services.openbao` lacks dev mode
      systemd.services.openbao-dev = {
        description = "OpenBao dev server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        path = [ pkgs.bash ];
        environment.HOME = "/root";
        serviceConfig.ExecStart = ''
          ${lib.getExe pkgs.openbao} server -dev \
            -dev-root-token-id=${config.environment.variables.BAO_TOKEN} \
            -dev-listen-address=127.0.0.1:8200
        '';
      };

      environment = {
        systemPackages = [ pkgs.openbao ];
        variables = {
          # dev mode binds 127.0.0.1 only, and the client tries `::1` first
          BAO_ADDR = "http://127.0.0.1:8200";
          BAO_TOKEN = "root";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("openbao-dev.service")
    machine.wait_for_open_port(8200)

    machine.wait_until_succeeds('bao kv put secret/example key=example')

    machine.wait_for_unit("openbao-agent-example.service")

    machine.wait_for_file("/example")
    machine.succeed('grep "example" /example')
  '';
}
