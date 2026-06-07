let
  port = 1234;
in
{
  name = "scanservjs";

  nodes.machine =
    { ... }:
    {
      services.scanservjs = {
        enable = true;
        settings.port = port;
      };
    };

  testScript = ''
    machine.wait_for_unit("scanservjs.service")
    machine.wait_until_succeeds(
        "curl --silent --fail --show-error --location http://localhost:${toString port}"
    )
  '';
}
