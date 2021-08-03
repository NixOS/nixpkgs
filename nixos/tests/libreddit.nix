import ./make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "libreddit";
  meta.maintainers = with maintainers; [ fab ];

  nodes.machine =
    { pkgs, ... }:
    { services.libreddit.enable = true; };

  testScript = ''
    machine.wait_for_unit("libreddit.service")
    machine.wait_for_open_port("8080")
    # The service wants to get data from https://www.reddit.com
    machine.succeed("curl http://localhost:8080/")
  '';
})
