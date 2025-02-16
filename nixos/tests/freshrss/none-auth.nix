import ../make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "freshrss-none-auth";
    meta.maintainers = with lib.maintainers; [ mattchrist ];

    nodes.machine =
      { pkgs, ... }:
      {
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
      assert '<title>Main stream · FreshRSS</title>' in response, "FreshRSS stream page didn't load successfully"
    '';
  }
)
