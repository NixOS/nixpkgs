{ lib, pkgs, ... }:
{
  name = "systemd-initrd-luks-tpm2";

  nodes.machine =
    { pkgs, ... }:
    {
      # Use systemd-boot
      virtualisation = {
        emptyDiskImages = [ 512 ];
        useBootLoader = true;
        # Booting off the TPM2-encrypted device requires an available init script
        mountHostNixStore = true;
        efi.OVMF = pkgs.OVMFFull; # this really should be the default. Only OVMFFull contains TCG
        useEFIBoot = true;
        tpm.enable = true;
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
    # Create encrypted volume
    machine.wait_for_unit("multi-user.target")
    machine.succeed("echo -n supersecret | cryptsetup luksFormat -q --iter-time=1 /dev/vdb -")
    machine.succeed("PASSWORD=supersecret SYSTEMD_LOG_LEVEL=debug systemd-cryptenroll --tpm2-pcrs= --tpm2-device=auto /dev/vdb |& systemd-cat")

    # Boot from the encrypted disk
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-luks.conf")
    machine.succeed("sync")
    machine.crash()

    # Boot and decrypt the disk
    machine.wait_for_unit("multi-user.target")
    assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount")
  '';
}
