{
  name = "systemd-pstore";

  nodes.machine = { };

  testScript = ''
    with subtest("pstore API fs is mounted"):
      machine.succeed("stat /sys/fs/pstore")

    with subtest("systemd-pstore.service doesn't run because nothing crashed"):
      output = machine.execute("systemctl status systemd-pstore.service", check_return=False)[1]
      t.assertIn("condition unmet", output)
  '';
}
