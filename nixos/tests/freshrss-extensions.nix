import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "freshrss";

    nodes.machine =
      { pkgs, ... }:
      {
        services.freshrss = {
          enable = true;
          baseUrl = "http://localhost";
          authType = "none";
          extensions = [ pkgs.freshrss-extensions.youtube ];
        };
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_open_port(80)
      response = machine.succeed("curl -vvv -s http://127.0.0.1:80/i/?c=extension")
      assert '<span class="ext_name disabled">YouTube Video Feed</span>' in response, "Extension not present in extensions page."
    '';
  }
)
