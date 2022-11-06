import ./make-test-python.nix ({ lib, pkgs, ... }: let
  passphrase = "supersecret";
in {
  name = "systemd-initrd-luks-osk-sdl";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ tomfitzhenry ];
  };

  enableOCR = true;

  nodes.machine = { pkgs, ... }: {
    virtualisation = {
      # Make room for GL in the initrd.
      bootPartitionSize = 250;
      emptyDiskImages = [ 512 512 ];
      useBootLoader = true;
      useEFIBoot = true;
      qemu.options = [
        "-vga virtio"
      ];
    };
    boot.loader.systemd-boot.enable = true;

    environment.systemPackages = with pkgs; [ cryptsetup ];
    boot.initrd = {
      systemd.enable = true;
      osk-sdl.enable = true;
    };

    specialisation.boot-luks.configuration = {
      boot.initrd.luks.devices = lib.mkVMOverride {
        # We have two disks and only type one password - key reuse is in place
        cryptroot.device = "/dev/vdc";
        cryptroot2.device = "/dev/vdd";
      };
      virtualisation.bootDevice = "/dev/mapper/cryptroot";
    };
  };

  testScript = ''
    # Create encrypted volume
    machine.wait_for_unit("multi-user.target")
    machine.succeed("echo -n ${passphrase} | cryptsetup luksFormat -q --iter-time=1 /dev/vdc -")
    machine.succeed("echo -n ${passphrase} | cryptsetup luksFormat -q --iter-time=1 /dev/vdd -")

    # Boot from the encrypted disk
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-luks.conf")
    machine.succeed("sync")
    machine.crash()

    # Boot and decrypt the disk
    machine.start()
    import time
    machine.wait_for_text("Enter disk decryption passphrase")
    machine.screenshot("prompt")
    for c in "${passphrase}":
        machine.send_chars(c)
        time.sleep(1)
    machine.screenshot("pw")
    machine.send_chars("\n")
    machine.wait_for_unit("multi-user.target")

    assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount")

  '';
})
