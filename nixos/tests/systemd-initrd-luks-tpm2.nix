{ lib, ... }:
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

      environment.systemPackages = with pkgs; [
        cryptsetup
        tpm2-tools
      ];

      specialisation.boot-luks.configuration = {
        boot.initrd.luks.devices = lib.mkVMOverride {
          cryptroot = {
            device = "/dev/vdb";
            crypttabExtraOpts = [
              "tpm2-device=auto"
              "tpm2-measure-pcr=yes"
            ];
          };
        };
        # The volume key measurement is only performed when the OS is explicitly
        # marked as measured (or booted through a measuring kernel stub).
        boot.kernelParams = [ "systemd.tpm2_measured_os=1" ];

        virtualisation.rootDevice = "/dev/mapper/cryptroot";
      };
    };

  testScript =
    { nodes, ... }:
    let
      boot-luks = nodes.machine.specialisation.boot-luks.configuration.system.build.toplevel;
    in
    # python
    ''
      # Create encrypted volume
      machine.wait_for_unit("multi-user.target")
      machine.succeed("echo -n supersecret | cryptsetup luksFormat -q --iter-time=1 /dev/vdb -")
      machine.succeed("echo -n supersecret | cryptsetup luksOpen -q /dev/vdb cryptroot")
      machine.succeed("mkfs.ext4 /dev/mapper/cryptroot")
      machine.succeed("PASSWORD=supersecret SYSTEMD_LOG_LEVEL=debug systemd-cryptenroll --tpm2-pcrs= --tpm2-device=auto /dev/vdb |& systemd-cat")

      # Boot from the encrypted disk
      machine.succeed("${boot-luks}/bin/switch-to-configuration boot")
      machine.succeed("sync")
      machine.crash()

      # Boot and decrypt the disk
      machine.wait_for_unit("multi-user.target")
      assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount")

      # The volume key has to be measured into PCR 15 through the
      # io.systemd.PCRExtend socket during initrd.
      machine.succeed("grep -q volume-key /run/log/systemd/tpm2-measure.log")
      pcr = machine.succeed("tpm2_pcrread sha256:15")
      assert "15: 0x0000000000000000000000000000000000000000000000000000000000000000" not in pcr, pcr
    '';
}
