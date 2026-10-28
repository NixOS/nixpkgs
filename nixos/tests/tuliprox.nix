{ lib, pkgs, ... }:
{
  name = "tuliprox";
  meta.maintainers = with lib.maintainers; [ nyanloutre ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.tuliprox = {
        enable = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.wait_for_open_port(8901)
    machine.succeed("curl -v -s http://127.0.0.1:8901/")
  '';
}
