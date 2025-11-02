{ lib, pkgs, ... }:
let

  keyfile = pkgs.writeText "luks-keyfile" ''
    MIGHAoGBAJ4rGTSo/ldyjQypd0kuS7k2OSsmQYzMH6TNj3nQ/vIUjDn7fqa3slt2
    gV6EK3TmTbGc4tzC1v4SWx2m+2Bjdtn4Fs4wiBwn1lbRdC6i5ZYCqasTWIntWn+6
    FllUkMD5oqjOR/YcboxG8Z3B5sJuvTP9llsF+gnuveWih9dpbBr7AgEC
  '';

in
{
  name = "systemd-initrd-luks-keyfile";

  nodes.machine =
    { pkgs, ... }:
    {
      # Use systemd-boot
      virtualisation = {
        emptyDiskImages = [
          {
            size = 512;
            driveConfig.deviceExtraOpts.serial = "new-root";
          }
          {
            size = 512;
            driveConfig.deviceExtraOpts.serial = "key";
          }
        ];
        useBootLoader = true;
        # Necessary to boot off the encrypted disk because it requires a init script coming from the Nix store
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
        testing.initrdBackdoor = true;
        boot.initrd.luks.devices = lib.mkVMOverride {
          cryptroot = {
            device = "/dev/disk/by-id/virtio-new-root";
            keyFile = "/keyfile:/dev/disk/by-id/virtio-key";
          };
        };
        virtualisation.rootDevice = "/dev/mapper/cryptroot";
        virtualisation.fileSystems."/".autoFormat = true;
      };
    };

  testScript = ''
    import re

    # Create encrypted volume
    machine.wait_for_unit("multi-user.target")
    machine.succeed(
      "mkfs.ext4 /dev/disk/by-id/virtio-key",
      "mkdir /mnt",
      "mount /dev/disk/by-id/virtio-key /mnt",
      "cp ${keyfile} /mnt/keyfile",
      "chmod 0600 /mnt/keyfile",
      "cryptsetup luksFormat -q --iter-time=1 -d /mnt/keyfile /dev/disk/by-id/virtio-new-root",
      "umount /mnt",
    )

    # Boot from the encrypted disk
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-luks.conf")
    machine.succeed("sync")
    machine.crash()

    # Boot and decrypt the disk
    machine.wait_for_unit("initrd.target")
    assert not re.search(r"/dev/vd.* on .* type ext4", machine.succeed("mount")), "Key file system should be unmounted automatically"
    machine.switch_root()
    machine.wait_for_unit("multi-user.target")
    assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount"), "Booted wrong rootfs"
  '';
}
