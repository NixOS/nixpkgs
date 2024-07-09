import ./make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "glitchtip";
  meta.maintainers = with maintainers; [ soyouzpanda ];

  nodes.machine = { ... }:
    {
      services.glitchtip = {
        enable = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("glitchtip.service")
    machine.wait_for_open_port(8080)
    machine.succeed("curl --fail http://127.0.0.1:8080")
  '';
})
