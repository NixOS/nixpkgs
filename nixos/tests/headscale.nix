import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "headscale";
  meta.maintainers = with lib.maintainers; [ misterio77 ];

  nodes.machine = { ... }: {
    services.headscale.enable = true;
    environment.systemPackages = [ pkgs.headscale ];
  };

  testScript = ''
    machine.wait_for_unit("headscale")
    machine.wait_for_open_port(8080)
    # Test basic functionality
    machine.succeed("headscale namespaces create test")
    machine.succeed("headscale preauthkeys -u test create")
  '';
})
