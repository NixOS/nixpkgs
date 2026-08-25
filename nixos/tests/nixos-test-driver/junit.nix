# This tests the generation of junit files via the test driver.
{
  name = "junit";

  extraDriverArgs = [ "--junit=junit.xml" ];

  nodes.machine = {
    # Speeds up the boot significantly
    networking.useNetworkd = true;

    environment.etc."something".text = "nothing";
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    with subtest("systemd-networkd is started"):
      machine.succeed("systemctl status systemd-networkd.service")

    with subtest("/etc is populated correctly"):
      output = machine.succeed("cat /etc/something")
      t.assertEqual(output, "nothing")
  '';
}
