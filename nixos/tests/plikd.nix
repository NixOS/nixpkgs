{ lib, ... }:
{
  name = "plikd";
  meta = with lib.maintainers; {
    maintainers = [ freezeboy ];
  };

  nodes.machine =
    { pkgs, ... }:
    let
    in
    {
      services.plikd.enable = true;
      environment.systemPackages = [ pkgs.plik ];
    };

  testScript = ''
    # Service basic test
    machine.wait_for_unit("plikd")

    # Network test
    machine.wait_for_open_port(8080)
    machine.succeed("curl --fail -v http://localhost:8080")

    # Application test
    machine.execute("echo test > /tmp/data.txt")
    machine.succeed("plik --server http://localhost:8080 /tmp/data.txt | grep curl")

    machine.succeed("diff data.txt /tmp/data.txt")
  '';
}
