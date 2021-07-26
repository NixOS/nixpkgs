import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "nitter";
  meta.maintainers = with pkgs.lib.maintainers; [ erdnaxe ];

  nodes.machine = {
    services.nitter.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("nitter.service")
    machine.wait_for_open_port("8080")
    machine.succeed("curl --fail http://localhost:8080/")
  '';
})
