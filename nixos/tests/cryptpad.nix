import ./make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "cryptpad";
  meta.maintainers = with maintainers; [ davhau ];

  nodes.machine =
    { pkgs, ... }:
    { services.cryptpad.enable = true; };

  testScript = ''
    machine.wait_for_unit("cryptpad.service")
    machine.wait_for_open_port("3000")
    machine.succeed("curl -L --fail http://localhost:3000/sheet")
  '';
})
