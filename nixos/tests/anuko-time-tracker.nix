{ pkgs, ... }:
{
  name = "anuko-time-tracker";
  meta = {
    maintainers = [ ];
  };
  nodes = {
    machine = {
      services.anuko-time-tracker.enable = true;
    };
  };
  testScript = ''
    start_all()
    machine.wait_for_unit("phpfpm-anuko-time-tracker")
    machine.wait_for_open_port(80);
    machine.wait_until_succeeds("curl -s --fail -L http://localhost/time.php | grep 'Anuko Time Tracker'")
  '';
}
