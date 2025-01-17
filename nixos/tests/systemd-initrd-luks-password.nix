import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "systemd-initrd-luks-password";

    nodes.machine =
      { pkgs, ... }:
      {
        # Use systemd-boot
        virtualisation = {
          emptyDiskImages = [
            512
            512
          ];
          useBootLoader = true;
          # Booting off the encrypted disk requires an available init script
          mountHostNixStore = true;
          useEFIBoot = true;
        };
        boot.loader.systemd-boot.enable = true;

        environment.systemPackages = with pkgs; [ cryptsetup ];
        boot.initrd.systemd = {
          enable = true;
          emergencyAccess = true;
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
      machine.succeed("echo -n supersecret | cryptsetup luksFormat -q --iter-time=1 /dev/vdb -")
      machine.succeed("echo -n supersecret | cryptsetup luksFormat -q --iter-time=1 /dev/vdc -")
      machine.succeed("echo -n supersecret | cryptsetup luksOpen   -q               /dev/vdc cryptroot2")
      machine.succeed("mkfs.ext4 /dev/mapper/cryptroot2")

      # Boot from the encrypted disk
      machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-luks.conf")
      machine.succeed("sync")
      machine.crash()

      # Boot and decrypt the disk
      machine.start()
      machine.wait_for_console_text("Please enter passphrase for disk cryptroot")
      machine.send_console("supersecret\n")
      machine.wait_for_unit("multi-user.target")

      assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount"), "/dev/mapper/cryptroot do not appear in mountpoints list"
      assert "/dev/mapper/cryptroot2 on /cryptroot2 type ext4" in machine.succeed("mount")
    '';
  }
)
