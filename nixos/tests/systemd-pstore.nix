{
  name = "systemd-pstore";

  nodes.machine = {
    virtualisation.useEFIBoot = true;
    boot.initrd.systemd.enable = true;
    testing.initrdBackdoor = true;
  };

  testScript = ''
    machine.switch_root()
    with subtest("pstore API fs is mounted"):
      machine.succeed("stat /sys/fs/pstore")

    with subtest("systemd-pstore.service doesn't run because nothing crashed"):
      output = machine.execute("systemctl status systemd-pstore.service", check_return=False)[1]
      t.assertIn("condition unmet", output)
      machine.fail("stat /var/lib/systemd/pstore/*/*/dmesg.txt")

    with subtest("systemd-pstore.service saves dmesg.txt files"):
      machine.execute("echo c > /proc/sysrq-trigger", check_return=False, check_output=False)
      machine.wait_for_shutdown()
      machine.switch_root()
      machine.wait_for_unit("systemd-pstore.service")
      machine.succeed("stat /var/lib/systemd/pstore/*/*/dmesg.txt")

    with subtest("crashes in initrd can be recovered too"):
      machine.succeed(
        "rm -r /var/lib/systemd/pstore/*",
        "sync",
      )
      machine.shutdown()
      machine.execute("echo c > /proc/sysrq-trigger", check_return=False, check_output=False)
      machine.wait_for_shutdown()
      machine.switch_root()
      machine.wait_for_unit("systemd-pstore.service")
      machine.succeed("stat /var/lib/systemd/pstore/*/*/dmesg.txt")
  '';
}
