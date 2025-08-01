{ lib, ... }:
{
  name = "freshrss-http-auth";
  meta.maintainers = with lib.maintainers; [ mattchrist ];

  nodes.machine = {
    services.freshrss = {
      enable = true;
      baseUrl = "http://localhost";
      dataDir = "/srv/freshrss";
      authType = "http_auth";
    };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_open_port(80)
    response = machine.succeed("curl -vvv -s -H 'Host: freshrss' -H 'Remote-User: testuser' http://localhost:80/i/")
    assert 'Account: testuser' in response, "http_auth method didn't work."
  '';
}
