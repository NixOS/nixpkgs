{ lib, ... }:
{
  name = "systemd-initrd-luks-password-to-keyfile";

  nodes.machine =
    { pkgs, ... }:
    {
      # Use systemd-boot
      virtualisation = {
        emptyDiskImages = [
          512
          512
          512
        ];
        useBootLoader = true;
        # Booting off the encrypted disk requires an available init script
        mountHostNixStore = true;
        useEFIBoot = true;
      };
      boot.loader.systemd-boot.enable = true;

      environment.systemPackages = [ pkgs.cryptsetup ];
      boot.initrd.systemd = {
        enable = true;
        emergencyAccess = true;
      };

      specialisation.boot-luks.configuration = {
        boot.initrd.luks.devices = lib.mkVMOverride {
          cryptkey.device = "/dev/vdb";
          cryptroot = {
            device = "/dev/vdc";
            keyFile = "/dev/mapper/cryptkey";
            keyFileSize = 1024;
          };
          cryptroot2 = {
            device = "/dev/vdd";
            keyFile = "/dev/mapper/cryptkey";
            keyFileSize = 1024;
          };
        };
        virtualisation.rootDevice = "/dev/mapper/cryptroot";
        # test mounting device unlocked in initrd after switching root
        virtualisation.fileSystems."/cryptroot2" = {
          device = "/dev/mapper/cryptroot2";
          fsType = "auto";
        };
      };
    };

  testScript = /* python */ ''
    # Create encrypted volume
    machine.wait_for_unit("multi-user.target")

    machine.succeed("echo -n supersecret | cryptsetup luksFormat -q --iter-time=1 /dev/vdb -")
    machine.succeed("echo -n supersecret | cryptsetup luksOpen   -q               /dev/vdb cryptkey")
    machine.succeed("dd if=/dev/urandom of=/dev/mapper/cryptkey bs=1024 count=1")

    machine.succeed("cryptsetup luksFormat -q --keyfile-size 1024 /dev/vdc /dev/mapper/cryptkey")
    machine.succeed("cryptsetup luksFormat -q --keyfile-size 1024 /dev/vdd /dev/mapper/cryptkey")

    machine.succeed("cryptsetup luksOpen -q --keyfile-size 1024 --key-file /dev/mapper/cryptkey /dev/vdc cryptroot")
    machine.succeed("cryptsetup luksOpen -q --keyfile-size 1024 --key-file /dev/mapper/cryptkey /dev/vdd cryptroot2")

    machine.succeed("mkfs.ext4 /dev/mapper/cryptroot")
    machine.succeed("mkfs.ext4 /dev/mapper/cryptroot2")

    # Boot from the encrypted disk
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-luks.conf")
    machine.succeed("sync")
    machine.crash()

    # Boot and decrypt the disk
    machine.start()
    machine.wait_for_console_text("Please enter passphrase for disk cryptkey")
    machine.send_console("supersecret\n")
    machine.wait_for_unit("multi-user.target")

    assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount"), "/dev/mapper/cryptroot do not appear in mountpoints list"
    assert "/dev/mapper/cryptroot2 on /cryptroot2 type ext4" in machine.succeed("mount")
  '';
}
