{ pkgs, ... }:
{
  name = "grav";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.grav.enable = true;
      };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("phpfpm-grav.service")
    machine.wait_for_open_port(80)

    # The first request to a fresh install should result in a redirect to the
    # admin page, where the user is expected to set up an admin user.
    actual = machine.succeed("curl -v --stderr - http://localhost/", timeout=10).splitlines()
    expected = "< Location: /admin"
    assert expected in actual, \
      f"unexpected reply from Grav: '{actual}'"
  '';
}
