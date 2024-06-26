import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "redlib";
  meta.maintainers = with lib.maintainers; [ soispha ];

  nodes.machine = {
    services.libreddit = {
      package = pkgs.redlib;
      enable = true;
      # Test CAP_NET_BIND_SERVICE
      port = 80;
    };
  };

  testScript = ''
    machine.wait_for_unit("libreddit.service")
    machine.wait_for_open_port(80)
    # Query a page that does not require Internet access
    machine.succeed("curl --fail http://localhost:80/settings")
  '';
})
