import ../make-test-python.nix (
  { ... }:
  {
    name = "authentik-nixos";

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [ openssl ];

        services.authentik = {
          enable = true;
          secretsFile = "/run/secrets/authentik";
          environment.AUTHENTIK_LOG_LEVEL = "debug";
        };
      };

    testScript = ''
      machine.succeed("mkdir -p /run/secrets ; echo \"AUTHENTIK_SECRET_KEY=$(openssl rand -base64 60 | tr -d '\n')\" > /run/secrets/authentik ; echo \"AUTHENTIK_BOOTSTRAP_PASSWORD=admin\" >> /run/secrets/authentik")

      machine.wait_for_unit("authentik-server.service")

      machine.wait_for_open_port(9000)
      machine.wait_until_succeeds("curl --fail http://localhost:9000/api/v3/root/config", 100)
    '';
  }
)
