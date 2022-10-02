import ./make-test-python.nix ({ pkgs, ... }: {
  name = "systemd-cryptenroll";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ ymatsiuk ];
  };

  nodes.machine = { pkgs, lib, ... }: {
    environment.systemPackages = [ pkgs.cryptsetup ];
    virtualisation = {
      emptyDiskImages = [ 512 ];
      qemu.options = [
        "-chardev socket,id=chrtpm,path=/tmp/swtpm-sock"
        "-tpmdev emulator,id=tpm0,chardev=chrtpm"
        "-device tpm-tis,tpmdev=tpm0"
      ];
    };
  };

  testScript = ''
    import subprocess
    import tempfile

    def start_swtpm(tpmstate):
        subprocess.Popen(["${pkgs.swtpm}/bin/swtpm", "socket", "--tpmstate", "dir="+tpmstate, "--ctrl", "type=unixio,path=/tmp/swtpm-sock", "--log", "level=0", "--tpm2"])

    with tempfile.TemporaryDirectory() as tpmstate:
        start_swtpm(tpmstate)
        machine.start()

        # Verify the TPM device is available and accessible by systemd-cryptenroll
        machine.succeed("test -e /dev/tpm0")
        machine.succeed("test -e /dev/tpmrm0")
        machine.succeed("systemd-cryptenroll --tpm2-device=list")

        # Create LUKS partition
        machine.succeed("echo -n lukspass | cryptsetup luksFormat -q /dev/vdb -")
        # Enroll new LUKS key and bind it to Secure Boot state
        # For more details on PASSWORD variable, check the following issue:
        # https://github.com/systemd/systemd/issues/20955
        machine.succeed("PASSWORD=lukspass systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=7 /dev/vdb")
        # Add LUKS partition to /etc/crypttab to test auto unlock
        machine.succeed("echo 'luks /dev/vdb - tpm2-device=auto' >> /etc/crypttab")
        machine.shutdown()

        start_swtpm(tpmstate)
        machine.start()

        # Test LUKS partition automatic unlock on boot
        machine.wait_for_unit("systemd-cryptsetup@luks.service")
        # Wipe TPM2 slot
        machine.succeed("systemd-cryptenroll --wipe-slot=tpm2 /dev/vdb")
  '';
})

