import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "luks";

  nodes.machine = { pkgs, ... }: {
    imports = [ ./common/auto-format-root-device.nix ];

    # Use systemd-boot
    virtualisation = {
      emptyDiskImages = [ 512 512 ];
      useBootLoader = true;
      useEFIBoot = true;
      # To boot off the encrypted disk, we need to have a init script which comes from the Nix store
      mountHostNixStore = true;
    };
    boot.loader.systemd-boot.enable = true;

    boot.kernelParams = lib.mkOverride 5 [ "console=tty1" ];

    environment.systemPackages = with pkgs; [ cryptsetup ];

    specialisation = rec {
      boot-luks.configuration = {
        boot.initrd.luks.devices = lib.mkVMOverride {
          # We have two disks and only type one password - key reuse is in place
          cryptroot.device = "/dev/vdb";
          cryptroot2.device = "/dev/vdc";
        };
        virtualisation.rootDevice = "/dev/mapper/cryptroot";
      };
      boot-luks-custom-keymap.configuration = lib.mkMerge [
        boot-luks.configuration
        {
          console.keyMap = "neo";
        }
      ];
    };
  };

  enableOCR = true;

  testScript = ''
    # Create encrypted volume
    machine.wait_for_unit("multi-user.target")
    machine.succeed("echo -n supersecret | cryptsetup luksFormat -q --iter-time=1 /dev/vdb -")
    machine.succeed("echo -n supersecret | cryptsetup luksFormat -q --iter-time=1 /dev/vdc -")

    # Boot from the encrypted disk
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-luks.conf")
    machine.succeed("sync")
    machine.crash()

    # Boot and decrypt the disk
    machine.start()
    machine.wait_for_text("Passphrase for")
    machine.send_chars("supersecret\n")
    machine.wait_for_unit("multi-user.target")

    assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount")

    # Boot from the encrypted disk with custom keymap
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-luks-custom-keymap.conf")
    machine.succeed("sync")
    machine.crash()

    # Boot and decrypt the disk
    machine.start()
    machine.wait_for_text("Passphrase for")
    machine.send_chars("havfkhfrkfl\n")
    machine.wait_for_unit("multi-user.target")

    assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount")
  '';
})
