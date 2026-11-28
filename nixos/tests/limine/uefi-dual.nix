{ lib, pkgs, ... }:
{
  name = "uefiDual";
  meta = {
    inherit (pkgs.limine.meta) maintainers;
  };

  meta.platforms = [
    "aarch64-linux"
    "i686-linux"
    "x86_64-linux"
  ];
  nodes.machine =
    { ... }:
    {
      virtualisation.useBootLoader = true;
      virtualisation.useEFIBoot = true;

      environment.systemPackages = [ pkgs.efibootmgr ];

      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.limine.enable = true;
      boot.loader.limine.efiSupport = true;
      boot.loader.limine.efiInstallAsRemovable = true;
      boot.loader.timeout = 0;
    };

  testScript =
    let
      binaryName = "BOOT${lib.toUpper pkgs.stdenv.hostPlatform.efiArch}.EFI";
    in
    ''
      machine.start()
      with subtest('Machine boots correctly'):
        machine.wait_for_unit('multi-user.target')

      with subtest('Removable bootloader exists'):
        machine.succeed('test -e /boot/EFI/BOOT/${binaryName}')

      with subtest('Non-removable bootloader exists'):
        machine.succeed('test -e /boot/EFI/limine/${binaryName}')

      with subtest('EFI boot entry exists'):
        machine.succeed('efibootmgr | grep "Limine"')
    '';
}
