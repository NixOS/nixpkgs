import ./make-test-python.nix ({ pkgs, ... }: {
  name = "crater";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ matthewcroughan ];
  };

  nodes = {
    client = { config, pkgs, ... }: {
      environment.systemPackages = [ pkgs.curl ];
    };
    crater = { config, pkgs, ... }: {
      services.crater = {
        enable = true;
      };
      networking.firewall.allowedTCPPorts =
        [
          # This is the same as the port defined below, via
          # virtualHosts.crater.listen
          (builtins.head config.services.httpd.virtualHosts.crater.listen).port
        ];
      services.httpd = {
        virtualHosts.crater.listen =
          [
            {
              "port" = 8070;
            }
          ];
        adminAddr = "itchy@scratchy.xxx";
      };
    };
  };
  testScript = ''
    start_all()
    crater.wait_for_unit("httpd.service")
    crater.wait_for_unit("phpfpm-crater.service")
    crater.wait_for_open_port("8070")

    client.wait_for_unit("multi-user.target")
    with subtest("Check that the Crater webserver can be reached."):
        assert "<title>Crater - Self Hosted Invoicing Platform</title>" in client.succeed(
            "curl -sSf http://crater:8070/on-boarding | grep title"
        )
  '';
})
