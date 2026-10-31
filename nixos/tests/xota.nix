{ pkgs, ... }:
{
  name = "xota";
  nodes = {
    machine = {
      services.xota = {
        enable = true;
        eventName = "Test";
      };
    };
  };
  testScript = ''
    start_all()
    machine.wait_for_unit("xota")
    machine.wait_for_open_port(80);
    machine.wait_until_succeeds("curl -s -L --fail http://localhost | grep 'TOTA at Test'")
  '';
}
