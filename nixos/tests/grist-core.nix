import ./make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "grist";
  meta.maintainers = with maintainers; [ soyouzpanda ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.grist-core.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("grist-core.service")
    machine.wait_for_open_port(8484)
    machine.succeed("curl --fail http://[::1]:8484")
  '';
})
