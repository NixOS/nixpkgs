{ ... }:
{
  name = "smartd";

  nodes.machine = {
    # QEMU's NVMe controller answers SMART queries, which a virtio disk does not.
    virtualisation.qemu.options = [
      "-drive if=none,id=smartnvme,format=raw,file=null-co://"
      "-device nvme,serial=smartdtest,drive=smartnvme"
    ];

    services.smartd = {
      enable = true;
      autodetect = false;
      devices = [ { device = "/dev/nvme0"; } ];
      notifications = {
        # Send one test alert per device when smartd starts.
        test = true;
        systembus-notify.enable = true;
        # wall is on by default; turn it off so systembus-notify is the only channel.
        wall.enable = false;
      };
    };
  };

  testScript = ''
    from datetime import timedelta

    machine.wait_for_unit("multi-user.target")

    # Listen on the system bus before smartd sends its test alert.
    # The monitor logs its own name signal once it is attached.
    machine.succeed(
        "systemd-run --unit=busmon -p StandardOutput=file:/tmp/busmon.log dbus-monitor --system"
    )
    machine.wait_until_succeeds("grep -qE 'member=Name(Acquired|Lost)' /tmp/busmon.log")

    machine.succeed("systemctl restart smartd.service")
    machine.wait_until_succeeds(
        "grep -q 'Problem detected with disk' /tmp/busmon.log",
        timeout=timedelta(seconds=60),
    )
  '';
}
