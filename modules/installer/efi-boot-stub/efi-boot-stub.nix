{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    boot = {
      loader = {
        efiBootStub = {

          enable = mkOption {
            default = false;
            description = ''
              Whether to use the linux kernel as an EFI bootloader.
              When enabled, the kernel, initrd, and an EFI shell script
              to boot the system are copied to the EFI system partition.
            '';
          };

          efiDisk = mkOption {
            default = "/dev/sda";
            description = ''
              The disk that contains the EFI system partition. Only used by
              efibootmgr
            '';
          };

          efiPartition = mkOption {
            default = "1";
            description = ''
              The partition number of the EFI system partition. Only used by
              efibootmgr
            '';
          };

          efiSysMountPoint = mkOption {
            default = "/boot";
            description = ''
              Where the EFI System Partition is mounted.
            '';
          };

          runEfibootmgr = mkOption {
            default = false;
            description = ''
              Whether to run efibootmgr to add the configuration to the boot options list.
              WARNING! efibootmgr has been rumored to brick Apple firmware! Use 'bless' on
              Apple efi systems.
            '';
          };

          installStartupNsh = mkOption {
            default = false;
            description = ''
              Whether to install a startup.nsh in the root of the EFI system partition.
              For now, it will just boot the latest version when run, the eventual goal
              is to have a basic menu-type interface.
            '';
          };

          installShell = mkOption {
            default = false;
            description = ''
              Whether to install an EFI shell in \EFI\BOOT.
              This _should_ only be needed for removable devices
              (CDs, usb sticks, etc.), but it may be an option for broken
              systems where efibootmgr doesn't work. Particularly useful in
              conjunction with installStartupNsh
            '';
          };

        };
      };
    };
  };

in

###### implementation
let
  efiBootStubBuilder = pkgs.substituteAll {
    src = ./efi-boot-stub-builder.sh;
    isExecutable = true;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep pkgs.glibc] ++ (pkgs.stdenv.lib.optionals config.boot.loader.efiBootStub.runEfibootmgr [pkgs.efibootmgr pkgs.module_init_tools]);
    inherit (config.boot.loader.efiBootStub) efiSysMountPoint runEfibootmgr installStartupNsh efiDisk efiPartition;

    efiShell = if config.boot.loader.efiBootStub.installShell then
      if pkgs.stdenv.isi686 then
        pkgs.fetchurl {
          url = "https://edk2.svn.sourceforge.net/svnroot/edk2/trunk/edk2/EdkShellBinPkg/FullShell/Ia32/Shell_Full.efi";
          sha256 = "0ymm3mbbwx9f6cq0bp2nr7ikyagxgsg4sjs5q1s4xbnms27slwjq";
        }
      else
        pkgs.fetchurl {
          url = "https://edk2.svn.sourceforge.net/svnroot/edk2/trunk/edk2/EdkShellBinPkg/FullShell/X64/Shell_Full.efi";
          sha256 = "1xchy8a05mgqzr82mmahdni0jbxsz6xf6vm2bg1bch9i6l72qgmh";
        }
    else
      null;

    kernelFile = platform.kernelTarget;
    targetArch = if pkgs.stdenv.isi686 then
      "IA32"
    else if pkgs.stdenv.isx86_64 then
      "X64"
    else
      throw "Unsupported architecture";
  };

  # Temporary check, for nixos to cope both with nixpkgs stdenv-updates and trunk
  platform = pkgs.stdenv.platform;
in
{
  require = [
    options

    # config.system.build
    # ../system/system-options.nix
  ];

  system = mkIf (config.boot.loader.efiBootStub.enable && (assert
    (config.boot.kernelPackages.kernel.features ? efiBootStub &&
    config.boot.kernelPackages.kernel.features.efiBootStub); true)) {
    build = {
      menuBuilder = efiBootStubBuilder;
    };
    boot.loader.id = "efiBootStub";
    boot.loader.kernelFile = platform.kernelTarget;
  };
}
