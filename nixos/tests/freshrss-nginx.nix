import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "freshrss";
    meta.maintainers = with lib.maintainers; [ mattchrist ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.freshrss = {
          enable = true;
          baseUrl = "http://localhost";
          passwordFile = pkgs.writeText "password" "secret";
          dataDir = "/srv/freshrss";
          nginx.virtualHost = {
            listen = [
              {
                addr = "127.0.0.1";
                port = 8081;
              }
            ];
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_open_port(8081)
      response = machine.succeed("curl -vvv -s -H 'Host: freshrss' http://127.0.0.1:8081/i/")
      assert '<title>Login · FreshRSS</title>' in response, "Login page didn't load successfully"
    '';
  }
)
