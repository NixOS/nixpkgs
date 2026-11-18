import ../make-test-python.nix (
  { lib, ... }:

  {
    name = "feishin-caddy";
    meta.maintainers = with lib.maintainers; [
      rharish
      BatteredBunny
    ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.feishin = {
          enable = true;
          domain = "localhost:80";
          pathbase = "/feishin";
          settings = {
            ANALYTICS_DISABLED = "true";
          };
          caddy.enable = true;
          caddy.virtualHost.extraConfig = "tls internal";
        };
        # disable letsencrypt cert fetching
        services.caddy.globalConfig = "auto_https disable_certs";
      };

    testScript = ''
      machine.wait_for_unit("caddy.service")
      machine.wait_for_open_port(80)
      machine.succeed("curl -vvv --fail --show-error --silent --location --insecure http://localhost/feishin/")
      assert "<title>Feishin</title>" in machine.succeed("curl --fail --show-error --silent --location --insecure http://localhost/feishin/")
      assert "window.ANALYTICS_DISABLED = \"true\";" in machine.succeed("curl --fail --show-error --silent --location --insecure http://localhost/feishin/settings.js")
    '';
  }
)
