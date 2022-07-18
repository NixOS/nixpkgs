import ./make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "libreddit";
  meta.maintainers = with maintainers; [ fab ];

  nodes.machine = {
    services.libreddit.enable = true;
    # Test CAP_NET_BIND_SERVICE
    services.libreddit.port = 80;
  };

  testScript = ''
    machine.wait_for_unit("libreddit.service")
    machine.wait_for_open_port(80)
    # Query a page that does not require Internet access
    machine.succeed("curl --fail http://localhost:80/settings")
  '';
})
