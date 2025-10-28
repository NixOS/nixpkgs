{ pkgs, ... }:
{

  name = "etesync-dav";
  meta = {
    maintainers = [ ];
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.curl
        pkgs.etesync-dav
      ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("etesync-dav --version")
    machine.execute("etesync-dav >&2 &")
    machine.wait_for_open_port(37358)
    with subtest("Check that the web interface is accessible"):
        assert "Add User" in machine.succeed("curl -s http://localhost:37358/.web/add/")
  '';
}
