import ./make-test-python.nix ({pkgs, lib, ...}:
{
  name = "openvscode-server";

  nodes = {
    machine = {pkgs, ...}: {
      services.openvscode-server = {
        enable = true;
        withoutConnectionToken = true;
      };
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("openvscode-server.service")
    machine.wait_for_open_port(3000)
    machine.succeed("curl -k --fail http://localhost:3000", timeout=10)
  '';

  meta.maintainers = [ lib.maintainers.drupol ];
})
