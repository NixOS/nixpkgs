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
<<<<<<< HEAD
    response = machine.succeed("curl --fail-with-body --silent http://localhost:80/i/")
=======
    response = machine.succeed("curl -vvv -s -H 'Host: freshrss' http://localhost:80/i/")
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    assert '<title>Login · FreshRSS</title>' in response, "Login page didn't load successfully"
  '';
}
