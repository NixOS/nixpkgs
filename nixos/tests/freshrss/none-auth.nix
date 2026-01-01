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
<<<<<<< HEAD
    response = machine.succeed("curl --fail-with-body --silent http://localhost:80/i/")
=======
    response = machine.succeed("curl -vvv -s http://localhost:80/i/")
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    assert '<title> · FreshRSS</title>' in response, "FreshRSS stream page didn't load successfully"
  '';
}
