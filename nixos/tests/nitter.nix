import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "nitter";
  meta.maintainers = with pkgs.lib.maintainers; [ erdnaxe ];

  nodes.machine = {
    services.nitter.enable = true;
    # Test CAP_NET_BIND_SERVICE
    services.nitter.server.port = 80;
  };

  testScript = ''
    machine.wait_for_unit("nitter.service")
    machine.wait_for_open_port(80)
    machine.succeed("curl --fail http://localhost:80/")
  '';
})
