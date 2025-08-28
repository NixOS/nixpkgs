{ lib, pkgs, ... }:
{
  name = "endlessh";
  meta.maintainers = with lib.maintainers; [ azahi ];

  nodes = {
    server =
      { ... }:
      {
        services.endlessh = {
          enable = true;
          openFirewall = true;
        };

        specialisation = {
          unprivileged.configuration.services.endlessh.port = 2222;

          privileged.configuration.services.endlessh.port = 22;
        };
      };

    client =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          curl
          netcat
        ];
      };
  };

  testScript = ''
    def activate_specialisation(name: str):
        server.succeed(f"/run/booted-system/specialisation/{name}/bin/switch-to-configuration test >&2")

    start_all()

    with subtest("Unprivileged"):
        activate_specialisation("unprivileged")
        server.wait_for_unit("endlessh.service")
        server.wait_for_open_port(2222)
        client.succeed("nc -dvW5 server 2222")

    with subtest("Privileged"):
        activate_specialisation("privileged")
        server.wait_for_unit("endlessh.service")
        server.wait_for_open_port(22)
        client.succeed("nc -dvW5 server 22")
  '';
}
