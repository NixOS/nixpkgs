import ./make-test-python.nix ({ lib, pkgs, ... }:
{
  name = "endlessh-go";
  meta.maintainers = with lib.maintainers; [ azahi ];

  nodes = {
    server = { ... }: {
      services.endlessh-go = {
        enable = true;
        prometheus.enable = true;
        openFirewall = true;
      };

      specialisation = {
        unprivileged.configuration = {
          services.endlessh-go = {
            port = 2222;
            prometheus.port = 9229;
          };
        };

        privileged.configuration = {
          services.endlessh-go = {
            port = 22;
            prometheus.port = 92;
          };
        };
      };
    };

    client = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ curl netcat ];
    };
  };

  testScript = ''
    def activate_specialisation(name: str):
        server.succeed(f"/run/booted-system/specialisation/{name}/bin/switch-to-configuration test >&2")

    start_all()

    with subtest("Unprivileged"):
        activate_specialisation("unprivileged")
        server.wait_for_unit("endlessh-go.service")
        server.wait_for_open_port(2222)
        server.wait_for_open_port(9229)
        client.succeed("nc -dvW5 server 2222")
        client.succeed("curl -kv server:9229/metrics")

    with subtest("Privileged"):
        activate_specialisation("privileged")
        server.wait_for_unit("endlessh-go.service")
        server.wait_for_open_port(22)
        server.wait_for_open_port(92)
        client.succeed("nc -dvW5 server 22")
        client.succeed("curl -kv server:92/metrics")
  '';
})
