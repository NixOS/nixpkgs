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

    with subtest("initrd should not report tainted"):
        output = machine.succeed("journalctl --boot --output=cat _PID=1")
        assert "System is tainted" not in output

    with subtest("activation migrates a /bin directory to a symlink"):
        machine.succeed("rm /bin && mkdir /bin && ln -s /usr/bin/sh /bin/sh")
        machine.succeed("/run/current-system/activate")
        machine.succeed("test \"$(readlink /bin)\" = usr/bin")
  '';
}
