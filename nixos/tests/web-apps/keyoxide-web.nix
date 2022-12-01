import ../make-test-python.nix ({ pkgs, lib, ... }: {
  name = "keyoxide-web";

  nodes.machine = { ... }: {
    services.keyoxide-web = {
      enable = true;
      port = 3000;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit('keyoxide-web')
    machine.wait_for_open_port(3000)
    machine.wait_until_succeeds('curl localhost:3000')
  '';

  meta.maintainers = with lib.maintainers; [ BrinkOfBailout ];
})

