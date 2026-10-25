{ lib, ... }:
{
  name = "nspawn-x11";
  meta.teams = [ lib.teams.test-driver ];

  containers.machine = {
    imports = [ ../common/x11.nix ];
    virtualisation.vlans = [ ];
  };

  testScript = ''
    import datetime as dt

    from test_driver.errors import RequestedAssertionFailed

    with subtest("waiting for X11 succeeds"):
        machine.wait_for_x()

    with subtest("waiting for X11 times out"):
        machine.succeed("systemctl stop display-manager.service")
        with t.assertRaises(RequestedAssertionFailed):
            machine.wait_for_x(timeout=dt.timedelta(seconds=1))
  '';
}
