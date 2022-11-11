import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "systemd-initrd-luks-fido2";

  nodes.machine = { pkgs, config, ... }: {
    # Use systemd-boot
    virtualisation = {
      emptyDiskImages = [ 512 ];
      useBootLoader = true;
      useEFIBoot = true;
      qemu.package = lib.mkForce (pkgs.qemu_test.override { canokeySupport = true; });
      qemu.options = [ "-device canokey,file=/tmp/canokey-file" ];
    };
    boot.loader.systemd-boot.enable = true;

    boot.initrd.systemd.enable = true;

    environment.systemPackages = with pkgs; [ cryptsetup ];

    specialisation.boot-luks.configuration = {
      boot.initrd.luks.devices = lib.mkVMOverride {
        cryptroot = {
          device = "/dev/vdc";
          crypttabExtraOpts = [ "fido2-device=auto" ];
        };
      };
      virtualisation.bootDevice = "/dev/mapper/cryptroot";
    };
  };

  testScript = ''
    # Create encrypted volume
    machine.wait_for_unit("multi-user.target")
    machine.succeed("echo -n supersecret | cryptsetup luksFormat -q --iter-time=1 /dev/vdc -")
    machine.succeed("PASSWORD=supersecret SYSTEMD_LOG_LEVEL=debug systemd-cryptenroll --fido2-device=auto /dev/vdc |& systemd-cat")

    # Boot from the encrypted disk
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-luks.conf")
    machine.succeed("sync")
    machine.crash()

    # Boot and decrypt the disk
    machine.wait_for_unit("multi-user.target")
    assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount")
  '';
})
