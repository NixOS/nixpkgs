{ lib, pkgs, ... }:
{
  name = "systemd-initrd-credentials";

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation = {
        qemu.options = [
          "-smbios type=11,value=io.systemd.credential:cred-smbios=secret-smbios"
        ];
      };

      boot.initrd.availableKernelModules = [ "dmi_sysfs" ];

      boot.kernelParams = [ "systemd.set_credential=cred-cmdline:secret-cmdline" ];

      boot.initrd.systemd = {
        enable = true;
      };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    # Check credential passed via kernel command line
    assert "secret-cmdline" in machine.succeed("systemd-creds --system cat cred-cmdline")

    # Check credential passed via SMBIOS
    assert "secret-smbios" in machine.succeed("systemd-creds --system cat cred-smbios")
  '';
}
