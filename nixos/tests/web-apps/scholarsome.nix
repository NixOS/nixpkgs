{ lib, pkgs, ... }:
{
  name = "scholarsome";

  meta = {
    maintainers = with lib.maintainers; [ vitto4 ];
  };

  nodes.machine =
    { ... }:
    {
      services.scholarsome = {
        enable = true;
        port = 8080;
        settings.JWT_SECRET = "super_secret_token_123";
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("scholarsome.service")
    machine.wait_for_open_port(8080, timeout=240)

    with subtest("Login page loads"):
        machine.succeed(
            "curl -sSfL http://127.0.0.1:8080/ | grep -i 'scholarsome'"
        )

    with subtest("Handbook page loads"):
        machine.succeed(
            "curl -sSfL http://127.0.0.1:8080/handbook/ | grep -i 'handbook'"
        )
  '';
}
