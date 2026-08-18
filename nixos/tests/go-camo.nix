{ lib, ... }:
let
  key_val = "12345678";
in
{
  name = "go-camo-file-key";
  meta = {
    maintainers = [ lib.maintainers.viraptor ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      services.go-camo = {
        enable = true;
        keyFile = pkgs.writeText "foo" key_val;
      };
    };

  # go-camo responds to http requests
  testScript = ''
    machine.wait_for_unit("go-camo.service")
    machine.wait_for_open_port(8080)
    machine.succeed("curl http://localhost:8080")
  '';
}
