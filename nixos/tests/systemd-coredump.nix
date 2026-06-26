{ pkgs, ... }:

let

  crasher = pkgs.writeCBin "crasher" "int main;";

  commonConfig = {
    systemd.services.crasher.serviceConfig = {
      ExecStart = "${crasher}/bin/crasher";
      StateDirectory = "crasher";
      WorkingDirectory = "%S/crasher";
      Restart = "no";
    };
  };

in

{
  name = "systemd-coredump";
  meta = {
    maintainers = [ ];
  };

  nodes.machine1 =
    { pkgs, lib, ... }:
    {
      imports = [ commonConfig ];
      systemd.coredump.settings.Coredump = {
        Storage = "journal";
        ProcessSizeMax = "0";
      };
    };
  nodes.machine2 =
    { pkgs, lib, ... }:
    {
      imports = [ commonConfig ];
      systemd.coredump.enable = false;
      systemd.package = pkgs.systemd.override {
        withCoredump = false;
      };
    };

  testScript = ''
    with subtest("systemd-coredump enabled"):
      machine1.wait_for_unit("multi-user.target")
      machine1.wait_for_unit("systemd-coredump.socket")
      machine1.systemctl("start crasher");
      machine1.wait_until_succeeds("coredumpctl list | grep crasher", timeout=10)
      machine1.fail("stat /var/lib/crasher/core*")

    with subtest("settings.Coredump renders coredump.conf"):
      machine1.succeed("grep -F '[Coredump]' /etc/systemd/coredump.conf")
      machine1.succeed("grep -F 'Storage=journal' /etc/systemd/coredump.conf")
      machine1.succeed("grep -F 'ProcessSizeMax=0' /etc/systemd/coredump.conf")

    with subtest("systemd-coredump disabled"):
      machine2.systemctl("start crasher");
      machine2.wait_until_succeeds("stat /var/lib/crasher/core*", timeout=10)
  '';
}
