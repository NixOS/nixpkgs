{ lib, ... }:
{
  name = "freshrss-none-auth";
  meta.maintainers = with lib.maintainers; [ mattchrist ];

  nodes.machine = {
    services.freshrss = {
      enable = true;
      baseUrl = "http://localhost";
      authType = "none";
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_open_port(80)
    response = machine.succeed("curl -vvv -s http://localhost:80/i/")
    assert '<title> · FreshRSS</title>' in response, "FreshRSS stream page didn't load successfully"
  '';
}
