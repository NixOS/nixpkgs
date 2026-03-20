{
  name = "systemd-initrd-credentials";

  nodes.machine = {
    testing.initrdBackdoor = true;

    virtualisation.credentials.cred-test.text = "secret-test";
    virtualisation.credentials.cred-test-fw_cfg = {
      mechanism = "fw_cfg";
      text = "secret-fw_cfg";
    };

    boot.initrd.availableKernelModules = [
      "dmi_sysfs"
      "qemu_fw_cfg"
    ];

    boot.kernelParams = [ "systemd.set_credential=cred-cmdline:secret-cmdline" ];

    boot.initrd.systemd.enable = true;
  };

  testScript = ''
    machine.wait_for_unit("initrd.target")

    t.assertIn("secret-cmdline", machine.succeed("systemd-creds --system cat cred-cmdline"))
    t.assertIn("secret-test",  machine.succeed("systemd-creds --system cat cred-test"))
    t.assertIn("secret-fw_cfg",  machine.succeed("systemd-creds --system cat cred-test-fw_cfg"))

  '';
}
