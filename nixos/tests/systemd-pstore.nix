{
  name = "systemd-pstore";

  nodes.machine = {
    boot.ramoops.enable = true;
    boot.kernel.sysctl."kernel.sysrq" = 1;
  };

  testScript = ''
    machine.start(allow_reboot=True)

    with subtest("pstore API fs is mounted"):
      machine.succeed("stat /sys/fs/pstore")

    with subtest("systemd-pstore.service doesn't run because nothing crashed"):
      output = machine.execute("systemctl status systemd-pstore.service", check_return=False)[1]
      t.assertIn("condition unmet", output)

    machine.wait_for_unit("multi-user.target")
    machine.execute("echo c > /proc/sysrq-trigger", check_output=False, check_return=False)
    machine.connected = False # We need to reconnect after the panic

    machine.wait_for_unit("systemd-pstore.service")
    machine.succeed("grep -r 'Kernel panic - not syncing: sysrq triggered crash' /var/lib/systemd/pstore")
  '';
}
