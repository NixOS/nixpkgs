{ pkgs, ... }:
{
  name = "systemd-no-tainted";

  nodes.machine = { };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    with subtest("systemctl should not report tainted with unmerged-usr"):
        output = machine.succeed("systemctl status")
        print(output)
        assert "Tainted" not in output
        assert "unmerged-usr" not in output
  '';
}
