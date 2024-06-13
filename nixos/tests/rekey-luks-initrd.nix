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

    specialisation = {
      boot-vuln-luks.configuration = {
        boot.initrd.luks.devices = lib.mkVMOverride {
          # We have two disks and only type one password - key reuse is in place
          cryptroot.device = "/dev/vdb";
          cryptroot2.device = "/dev/vdc";
        };
        virtualisation.rootDevice = "/dev/mapper/cryptroot";
      };
      rekey-procedure.configuration = {
        boot.initrd.luks.devices = lib.mkVMOverride {
          # We have two disks and only type one password - key reuse is in place
          cryptroot.device = "/dev/vdb";
          cryptroot2.device = "/dev/vdc";
        };
        virtualisation.rootDevice = "/dev/mapper/cryptroot";
        boot.kernelParams = [ "nixos.rekey" ];
      };
    };
  };

  enableOCR = true;

  testScript = ''
    # Create encrypted volume
    machine.wait_for_unit("multi-user.target")
    machine.succeed("echo -n supersecret | cryptsetup luksFormat -q --iter-time=1 /dev/vdb -")
    machine.succeed("echo -n supersecret | cryptsetup luksFormat -q --iter-time=1 /dev/vdc -")

    # Boot from the encrypted disk
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-vuln-luks.conf")
    machine.succeed("sync")
    machine.crash()

    # Boot and decrypt the disk
    machine.start()
    machine.wait_for_text("Passphrase for")
    machine.send_chars("supersecret\n")
    machine.wait_for_unit("multi-user.target")

    assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount")

    # Boot in one-shot for rekey procedure
    machine.succeed("bootctl set-oneshot nixos-generation-1-specialisation-rekey-procedure.conf")
    machine.succeed("sync")
    machine.crash()

    # Boot, decrypt it, rekey it, then decrypt it
    machine.start()
    machine.wait_for_text("Passphrase for")
    machine.send_chars("supersecret\n")
    # Change the old passphrase
    machine.wait_for_text("New passphrase for")
    machine.send_chars("newsecret\n")
    # New passphrase input
    machine.wait_for_text("Passphrase for")
    machine.send_chars("newsecret\n")
    machine.wait_for_unit("multi-user.target")

    assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount")
  '';
})
