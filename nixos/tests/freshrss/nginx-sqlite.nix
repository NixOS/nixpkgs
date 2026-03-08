{ lib, ... }:
{
  name = "freshrss-nginx-sqlite";
  meta.maintainers = with lib.maintainers; [
    etu
    stunkymonkey
  ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.freshrss = {
        enable = true;
        baseUrl = "http://localhost";
        passwordFile = pkgs.writeText "password" "secret";
        dataDir = "/srv/freshrss";
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_open_port(80)
    response = machine.succeed("curl --fail-with-body --silent http://localhost:80/i/")
    assert '<title>Login · FreshRSS</title>' in response, "Login page didn't load successfully"
  '';
}
