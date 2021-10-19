import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "crater";
  meta = with lib; {
    maintainers = with maintainers; [ onny ];
  };

  nodes = {
    crater = { config, pkgs, ... }: {
      services.crater.enable = true;
      environment.systemPackages = [ pkgs.curl ];
    };
  };

  testScript = ''
    crater.start()
    crater.wait_for_unit("caddy.service")
    crater.wait_for_unit("phpfpm-crater.service")
    crater.wait_for_open_port(80)
    crater.wait_for_unit("multi-user.target")
    with subtest("Check that the Crater webserver can be reached."):
        assert "Redirecting to" in crater.succeed(
            "curl -sSf http://localhost"
        )
  '';
})
