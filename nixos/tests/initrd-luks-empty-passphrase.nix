{
  systemdStage1,
  lib,
  pkgs,
  ...
}:
let
  keyfile = pkgs.writeText "luks-keyfile" ''
    MIGHAoGBAJ4rGTSo/ldyjQypd0kuS7k2OSsmQYzMH6TNj3nQ/vIUjDn7fqa3slt2
    gV6EK3TmTbGc4tzC1v4SWx2m+2Bjdtn4Fs4wiBwn1lbRdC6i5ZYCqasTWIntWn+6
    FllUkMD5oqjOR/YcboxG8Z3B5sJuvTP9llsF+gnuveWih9dpbBr7AgEC
  '';
in
{
  name = "initrd-luks-empty-passphrase";

  _module.args.systemdStage1 = lib.mkDefault false;

  nodes.machine =
    { pkgs, ... }:
    {
      imports = lib.optionals (!systemdStage1) [ ./common/auto-format-root-device.nix ];

      virtualisation = {
        emptyDiskImages = [ 512 ];
        useBootLoader = true;
        useEFIBoot = true;
        # This requires to have access
        # to a host Nix store as
        # the new root device is /dev/vdb
        # an empty 512MiB drive, containing no Nix store.
        mountHostNixStore = true;
        fileSystems."/".autoFormat = lib.mkIf systemdStage1 true;
      };

      boot.loader.systemd-boot.enable = true;
      boot.initrd.systemd = lib.mkIf systemdStage1 {
        enable = true;
        emergencyAccess = true;
      };
      environment.systemPackages = with pkgs; [ cryptsetup ];

      specialisation.boot-luks-wrong-keyfile.configuration = {
        boot.initrd.luks.devices = lib.mkVMOverride {
          cryptroot = {
            device = "/dev/vdb";
            keyFile = "/etc/cryptroot.key";
            tryEmptyPassphrase = true;
            fallbackToPassword = !systemdStage1;
          };
        };
        virtualisation.rootDevice = "/dev/mapper/cryptroot";
        boot.initrd.secrets."/etc/cryptroot.key" = keyfile;
      };

      specialisation.boot-luks-missing-keyfile.configuration = {
        boot.initrd.luks.devices = lib.mkVMOverride {
          cryptroot = {
            device = "/dev/vdb";
            keyFile = "/etc/cryptroot.key";
            tryEmptyPassphrase = true;
            fallbackToPassword = !systemdStage1;
          };
        };
        virtualisation.rootDevice = "/dev/mapper/cryptroot";
      };
    };

  testScript = ''
    # Encrypt key with empty key so boot should try keyfile and then fallback to empty passphrase


    def grub_select_boot_luks_wrong_key_file():
        """
        Selects "boot-luks" from the GRUB menu
        to trigger a login request.
        """
        machine.send_monitor_command("sendkey down")
        machine.send_monitor_command("sendkey down")
        machine.send_monitor_command("sendkey ret")

    def grub_select_boot_luks_missing_key_file():
        """
        Selects "boot-luks" from the GRUB menu
        to trigger a login request.
        """
        machine.send_monitor_command("sendkey down")
        machine.send_monitor_command("sendkey ret")

    # Create encrypted volume
    machine.wait_for_unit("multi-user.target")
    machine.succeed("echo "" | cryptsetup luksFormat /dev/vdb --batch-mode")
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-luks-wrong-keyfile.conf")
    machine.succeed("sync")
    machine.crash()

    # Check if rootfs is on /dev/mapper/cryptroot
    machine.wait_for_unit("multi-user.target")
    assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount")

    # Choose boot-luks-missing-keyfile specialisation
    machine.succeed("bootctl set-default nixos-generation-1-specialisation-boot-luks-missing-keyfile.conf")
    machine.succeed("sync")
    machine.crash()

    # Check if rootfs is on /dev/mapper/cryptroot
    machine.wait_for_unit("multi-user.target")
    assert "/dev/mapper/cryptroot on / type ext4" in machine.succeed("mount")
  '';
}
