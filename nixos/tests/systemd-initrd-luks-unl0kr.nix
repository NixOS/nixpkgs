import ./make-test-python.nix ({ lib, pkgs, ... }: let
  passphrase = "secret";
in {
  name = "systemd-initrd-luks-unl0kr";
  meta = {
    maintainers = [];
  };

  enableOCR = true;

  nodes.machine = { pkgs, ... }: {
    virtualisation = {
      emptyDiskImages = [ 512 512 ];
      useBootLoader = true;
      mountHostNixStore = true;
      useEFIBoot = true;
      qemu.options = [
        "-vga virtio"
      ];
    };
    boot.loader.systemd-boot.enable = true;

    boot.initrd.availableKernelModules = [
      "evdev" # for entering pw
      "bochs"
    ];

    environment.systemPackages = with pkgs; [ cryptsetup ];
    boot.initrd = {
      systemd = {
        enable = true;
        emergencyAccess = true;
      };
      unl0kr.enable = true;
    };

    specialisation.boot-luks.configuration = {
      boot.initrd.luks.devices = lib.mkVMOverride {
        # We have two disks and only type one password - key reuse is in place
        cryptroot.device = "/dev/vdb";
        cryptroot2.device = "/dev/vdc";
      };
      virtualisation.rootDevice = "/dev/mapper/cryptroot";
      virtualisation.fileSystems."/".autoFormat = true;
      # test mounting device unlocked in initrd after switching root
      virtualisation.fileSystems."/cryptroot2".device = "/dev/mapper/cryptroot2";
    };
  };

  testScript = ''
    # Create encrypted volume
    machine.wait_for_unit("multi-user.target")
    machine.succeed("echo -n ${passphrase} | cryptsetup luksFormat -q --iter-time=1 /dev/vdb -")
    machine.succeed("echo -n ${passphrase} | cryptsetup luksFormat -q --iter-time=1 /dev/vdc -")
    machine.succeed("echo -n ${passphrase} | cryptsetup luksOpen   -q               /dev/vdc cryptroot2")
    machine.succeed("mkfs.ext4 /dev/mapper/cryptroot2")

    # Boot from the encrypted disk
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-luks.conf")
    machine.succeed("sync")
    machine.crash()

    # Boot and decrypt the disk
    machine.start()
    machine.wait_for_text("Password required for booting")
    machine.screenshot("prompt")
    machine.send_chars("${passphrase}")
    machine.screenshot("pw")
    machine.send_chars("\n")
    machine.wait_for_unit("multi-user.target")

    assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount"), "/dev/mapper/cryptroot do not appear in mountpoints list"
    assert "/dev/mapper/cryptroot2 on /cryptroot2 type ext4" in machine.succeed("mount")
  '';
})
