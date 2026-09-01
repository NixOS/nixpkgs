{ pkgs, ... }:

let

  crasher = pkgs.writeCBin "crasher" "int main;";

in

{
  name = "systemd-coredump";
  meta = {
    maintainers = [ ];
  };

  nodes.machine = {
    systemd = {
      services.crasher.serviceConfig = {
        ExecStart = "${crasher}/bin/crasher";
        StateDirectory = "crasher";
        WorkingDirectory = "%S/crasher";
        Restart = "no";
      };

      coredump.settings.Coredump = {
        Storage = "journal";
        ProcessSizeMax = "0";
      };
    };
  };

  testScript = ''
    with subtest("systemd-coredump enabled"):
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("systemd-coredump.socket")
      machine.systemctl("start crasher");
      machine.wait_until_succeeds("coredumpctl list | grep crasher", timeout=10)
      machine.fail("stat /var/lib/crasher/core*")

    with subtest("settings.Coredump renders coredump.conf"):
      machine.succeed("grep -F '[Coredump]' /etc/systemd/coredump.conf")
      machine.succeed("grep -F 'Storage=journal' /etc/systemd/coredump.conf")
      machine.succeed("grep -F 'ProcessSizeMax=0' /etc/systemd/coredump.conf")
  '';
}
