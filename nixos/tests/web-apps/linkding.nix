{ lib, pkgs, ... }:
{
  name = "linkding";

  meta = {
    maintainers = with lib.maintainers; [ squat ];
  };

  nodes.machine =
    { ... }:
    {
      services.linkding = {
        enable = true;
        port = 9090;
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("linkding.service")
    machine.wait_for_open_port(9090)

    with subtest("Login page loads"):
        machine.succeed(
            "curl -sSfL http://127.0.0.1:9090 | grep -i 'linkding'"
        )

    with subtest("Health endpoint responds"):
        machine.succeed(
            "curl -sSf http://127.0.0.1:9090/health"
        )

    with subtest("linkding-manage works"):
        machine.succeed(
            "linkding-manage version"
        )
  '';
}
