import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "systemd-initrd-luks-tpm2";

  nodes.machine = { pkgs, ... }: {
    # Use systemd-boot
    virtualisation = {
      emptyDiskImages = [ 512 ];
      useBootLoader = true;
      # Booting off the TPM2-encrypted device requires an available init script
      mountHostNixStore = true;
      useEFIBoot = true;
      qemu.options = ["-chardev socket,id=chrtpm,path=/tmp/mytpm1/swtpm-sock -tpmdev emulator,id=tpm0,chardev=chrtpm -device tpm-tis,tpmdev=tpm0"];
    };
    boot.loader.systemd-boot.enable = true;

    boot.initrd.availableKernelModules = [ "tpm_tis" ];

    environment.systemPackages = with pkgs; [ cryptsetup ];
    boot.initrd.systemd = {
      enable = true;
    };

    specialisation.boot-luks.configuration = {
      boot.initrd.luks.devices = lib.mkVMOverride {
        cryptroot = {
          device = "/dev/vdb";
          crypttabExtraOpts = [ "tpm2-device=auto" ];
        };
      };
      virtualisation.rootDevice = "/dev/mapper/cryptroot";
      virtualisation.fileSystems."/".autoFormat = true;
    };
  };

  testScript = ''
    import subprocess
    import os
    import time


    class Tpm:
        def __init__(self):
            os.mkdir("/tmp/mytpm1")
            self.start()

        def start(self):
            self.proc = subprocess.Popen(["${pkgs.swtpm}/bin/swtpm", "socket", "--tpmstate", "dir=/tmp/mytpm1", "--ctrl", "type=unixio,path=/tmp/mytpm1/swtpm-sock", "--log", "level=20", "--tpm2"])

        def wait_for_death_then_restart(self):
            while self.proc.poll() is None:
                print("waiting for tpm to die")
                time.sleep(1)
            assert self.proc.returncode == 0
            self.start()

    tpm = Tpm()


    # Create encrypted volume
    machine.wait_for_unit("multi-user.target")
    machine.succeed("echo -n supersecret | cryptsetup luksFormat -q --iter-time=1 /dev/vdb -")
    machine.succeed("PASSWORD=supersecret SYSTEMD_LOG_LEVEL=debug systemd-cryptenroll --tpm2-pcrs= --tpm2-device=auto /dev/vdb |& systemd-cat")

    # Boot from the encrypted disk
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-luks.conf")
    machine.succeed("sync")
    machine.crash()

    tpm.wait_for_death_then_restart()

    # Boot and decrypt the disk
    machine.wait_for_unit("multi-user.target")
    assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount")
  '';
})
