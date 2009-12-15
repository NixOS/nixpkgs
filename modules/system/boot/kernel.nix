{ config, pkgs, ... }:

with pkgs.lib;

###### interface
let

  options = {
    boot = {
      kernelPackages = mkOption {
        default = pkgs.kernelPackages;
        example = pkgs.kernelPackages_2_6_25;
        description = "
          This option allows you to override the Linux kernel used by
          NixOS.  Since things like external kernel module packages are
          tied to the kernel you're using, it also overrides those.
          This option is a function that takes Nixpkgs as an argument
          (as a convenience), and returns an attribute set containing at
          the very least an attribute <varname>kernel</varname>.
          Additional attributes may be needed depending on your
          configuration.  For instance, if you use the NVIDIA X driver,
          then it also needs to contain an attribute
          <varname>nvidia_x11</varname>.
        ";
      };

      kernelParams = mkOption {
        default = [
          "selinux=0"
          "apm=on"
          "acpi=on"
          "console=tty1"
          "splash=verbose"
          "vga=0x317"
        ];
        description = "
          The kernel parameters.  If you want to add additional
          parameters, it's best to set
          <option>boot.extraKernelParams</option>.
        ";
      };

      extraKernelParams = mkOption {
        default = [
        ];
        example = [
          "debugtrace"
        ];
        description = "
          Additional user-defined kernel parameters.
        ";
      };

      extraModulePackages = mkOption {
        default = [];
        # !!! example = [pkgs.aufs pkgs.nvidia_x11];
        description = ''
          A list of additional packages supplying kernel modules.
        '';
      };

      kernelModules = mkOption {
        default = [];
        description = ''
          The set of kernel modules to be loaded in the second stage of
          the boot process.  Note that modules that are needed to
          mount the root file system should be added to
          <option>boot.initrd.kernelModules</option>.
        '';
      };

      initrd = {

        kernelModules = mkOption {
          default = [
            # Note: most of these (especially the SATA/PATA modules)
            # shouldn't be included by default since nixos-hardware-scan
            # detects them, but I'm keeping them for now for backwards
            # compatibility.
            
            # Some SATA/PATA stuff.        
            "ahci"
            "sata_nv"
            "sata_via"
            "sata_sis"
            "sata_uli"
            "ata_piix"
            "pata_marvell"
            
            # Standard SCSI stuff.
            "sd_mod"
            "sr_mod"
            
            # Standard IDE stuff.
            "ide_cd"
            "ide_disk"
            "ide_generic"
            
            # Filesystems.
            "ext2" "ext3"
            
            # Support USB keyboards, in case the boot fails and we only have
            # a USB keyboard.
            "uhci_hcd"
            "ehci_hcd"
            "ohci_hcd"
            "usbhid"

            # LVM.
            "dm_mod"

	    # All-mod-config case:
	    "unix"
	    "i8042" "pcips2" "serio" "atkbd" "xtkbd"
          ];
          description = "
            The set of kernel modules in the initial ramdisk used during the
            boot process.  This set must include all modules necessary for
            mounting the root device.  That is, it should include modules
            for the physical device (e.g., SCSI drivers) and for the file
            system (e.g., ext3).  The set specified here is automatically
            closed under the module dependency relation, i.e., all
            dependencies of the modules list here are included
            automatically.
          ";
        };

      };
    };

    system.modulesTree = mkOption {
      internal = true;
      default = [];
      description = "
        Tree of kernel modules.  This includes the kernel, plus modules
        built outside of the kernel.  Combine these into a single tree of
        symlinks because modprobe only supports one directory.
      ";
      merge = mergeListOption;

      # Convert the list of path to only one path.
      apply = pkgs.aggregateModules;
    };

  };
  
in

###### implementation
let
  kernelPackages = config.boot.kernelPackages;
  kernel = kernelPackages.kernel;
in

{
  require = [ options ];

  system.build = { inherit kernel; };
  system.modulesTree = [ kernel ] ++ config.boot.extraModulePackages;

  boot.kernelModules = [ "loop" ];

  # The Linux kernel >= 2.6.27 provides firmware.
  hardware.firmware = [ "${kernel}/lib/firmware" ];
}
