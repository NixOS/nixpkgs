import ../make-test-python.nix (
  { lib, ... }:

  {
    name = "feishin-nginx";
    meta.maintainers = with lib.maintainers; [
      rharish
      BatteredBunny
    ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.feishin = {
          enable = true;
          domain = "localhost";
          pathbase = "/feishin";
          settings = {
            ANALYTICS_DISABLED = "true";
          };
          nginx.enable = true;
        };
      };

    testScript = ''
      machine.wait_for_unit("nginx.service")
      machine.wait_for_open_port(80)
      machine.succeed("curl -vvv --fail --show-error --silent --location --insecure http://localhost/feishin/")
      assert "<title>Feishin</title>" in machine.succeed("curl --fail --show-error --silent --location --insecure http://localhost/feishin/")
      assert "window.ANALYTICS_DISABLED = \"true\";" in machine.succeed("curl --fail --show-error --silent --location --insecure http://localhost/feishin/settings.js")
    '';
  }
)
