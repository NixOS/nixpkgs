import ../make-test-python.nix (
  { lib, ... }:

  {
    name = "bentopdf-caddy";
    meta.maintainers = with lib.maintainers; [ stunkymonkey ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.bentopdf = {
          enable = true;
          domain = "localhost:80";
          caddy.enable = true;
          caddy.virtualHost.extraConfig = "tls internal";
        };
        # disable letsencrypt cert fetching
        services.caddy.globalConfig = "auto_https disable_certs";
      };

    testScript = ''
      machine.wait_for_unit("caddy.service")
      machine.wait_for_open_port(80)
      machine.succeed("curl -vvv --fail --show-error --silent --location --insecure http://localhost/")
      assert "<title>BentoPDF - The Privacy First PDF Toolkit</title>" in machine.succeed("curl --fail --show-error --silent --location --insecure http://localhost/")
    '';
  }
)
