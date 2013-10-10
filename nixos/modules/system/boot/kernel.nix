{ config, pkgs, ... }:

with pkgs.lib;

let

  kernel = config.boot.kernelPackages.kernel;

  kernelModulesConf = pkgs.writeText "nixos.conf"
    ''
      ${concatStringsSep "\n" config.boot.kernelModules}
    '';

in

{

  ###### interface

  options = {

    boot.kernelPackages = mkOption {
      default = pkgs.linuxPackages;
      # We don't want to evaluate all of linuxPackages for the manual
      # - some of it might not even evaluate correctly.
      defaultText = "pkgs.linuxPackages";
      example = "pkgs.linuxPackages_2_6_25";
      description = ''
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
      '';
    };

    boot.kernelParams = mkOption {
      default = [ ];
      description = ''
        The kernel parameters.  If you want to add additional
        parameters, it's best to set
        <option>boot.extraKernelParams</option>.
      '';
    };

    boot.extraKernelParams = mkOption {
      default = [ ];
      example = [ "boot.trace" ];
      description = "Additional user-defined kernel parameters.";
    };

    boot.consoleLogLevel = mkOption {
      type = types.int;
      default = 4;
      description = ''
        The kernel console log level.  Only log messages with a
        priority numerically less than this will appear on the
        console.
      '';
    };

    boot.vesa = mkOption {
      default = false;
      description = ''
        Whether to activate VESA video mode on boot.
      '';
    };

    boot.extraModulePackages = mkOption {
      default = [];
      # !!! example = [pkgs.nvidia_x11];
      description = "A list of additional packages supplying kernel modules.";
    };

    boot.kernelModules = mkOption {
      default = [];
      description = ''
        The set of kernel modules to be loaded in the second stage of
        the boot process.  Note that modules that are needed to
        mount the root file system should be added to
        <option>boot.initrd.availableKernelModules</option> or
        <option>boot.initrd.kernelModules</option>.
      '';
    };

    boot.initrd.availableKernelModules = mkOption {
      default = [];
      example = [ "sata_nv" "ext3" ];
      description = ''
        The set of kernel modules in the initial ramdisk used during the
        boot process.  This set must include all modules necessary for
        mounting the root device.  That is, it should include modules
        for the physical device (e.g., SCSI drivers) and for the file
        system (e.g., ext3).  The set specified here is automatically
        closed under the module dependency relation, i.e., all
        dependencies of the modules list here are included
        automatically.  The modules listed here are available in the
        initrd, but are only loaded on demand (e.g., the ext3 module is
        loaded automatically when an ext3 filesystem is mounted, and
        modules for PCI devices are loaded when they match the PCI ID
        of a device in your system).  To force a module to be loaded,
        include it in <option>boot.initrd.kernelModules</option>.
      '';
    };

    boot.initrd.kernelModules = mkOption {
      default = [];
      description = "List of modules that are always loaded by the initrd.";
    };

    system.modulesTree = mkOption {
      internal = true;
      default = [];
      description = ''
        Tree of kernel modules.  This includes the kernel, plus modules
        built outside of the kernel.  Combine these into a single tree of
        symlinks because modprobe only supports one directory.
      '';
      merge = mergeListOption;
      # Convert the list of path to only one path.
      apply = pkgs.aggregateModules;
    };

    system.requiredKernelConfig = mkOption {
      default = [];
      example = literalExample ''
        with config.lib.kernelConfig; [
          (isYes "MODULES")
          (isEnabled "FB_CON_DECOR")
          (isEnabled "BLK_DEV_INITRD")
        ]
      '';
      internal = true;
      type = types.listOf types.attrs;
      description = ''
        This option allows modules to specify the kernel config options that
        must be set (or unset) for the module to work. Please use the
        lib.kernelConfig functions to build list elements.
      '';
    };

  };


  ###### implementation

  config = {

    system.build = { inherit kernel; };

    system.modulesTree = [ kernel ] ++ config.boot.extraModulePackages;

    # Implement consoleLogLevel both in early boot and using sysctl
    # (so you don't need to reboot to have changes take effect).
    boot.kernelParams =
      [ "loglevel=${toString config.boot.consoleLogLevel}" ] ++
      optionals config.boot.vesa [ "vga=0x317" ];

    boot.kernel.sysctl."kernel.printk" = config.boot.consoleLogLevel;

    boot.kernelModules = [ "loop" ];

    boot.initrd.availableKernelModules =
      [ # Note: most of these (especially the SATA/PATA modules)
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

        # Support USB keyboards, in case the boot fails and we only have
        # a USB keyboard.
        "uhci_hcd"
        "ehci_hcd"
        "ehci_pci"
        "ohci_hcd"
        "xhci_hcd"
        "usbhid"
        "hid_generic"

        # Unix domain sockets (needed by udev).
        "unix"

        # Misc. stuff.
        "pcips2" "xtkbd"

        # To wait for SCSI devices to appear.
        "scsi_wait_scan"
      ];

    boot.initrd.kernelModules =
      [ # For LVM.
        "dm_mod"
      ];

    # The Linux kernel >= 2.6.27 provides firmware.
    hardware.firmware = [ "${kernel}/lib/firmware" ];

    # Create /etc/modules-load.d/nixos.conf, which is read by
    # systemd-modules-load.service to load required kernel modules.
    # FIXME: ensure that systemd-modules-load.service is restarted if
    # this file changes.
    environment.etc = singleton
      { target = "modules-load.d/nixos.conf";
        source = kernelModulesConf;
      };

    # Sigh.  This overrides systemd's systemd-modules-load.service
    # just so we can set a restart trigger.  Also make
    # multi-user.target pull it in so that it gets started if it
    # failed earlier.
    systemd.services."systemd-modules-load" =
      { description = "Load Kernel Modules";
        wantedBy = [ "sysinit.target" "multi-user.target" ];
        before = [ "sysinit.target" "shutdown.target" ];
        unitConfig =
          { DefaultDependencies = "no";
            Conflicts = "shutdown.target";
          };
        serviceConfig =
          { Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${config.systemd.package}/lib/systemd/systemd-modules-load";
            # Ignore failed module loads.  Typically some of the
            # modules in ‘boot.kernelModules’ are "nice to have but
            # not required" (e.g. acpi-cpufreq), so we don't want to
            # barf on those.
            SuccessExitStatus = "0 1";
          };
        restartTriggers = [ kernelModulesConf ];
      };

    lib.kernelConfig = {
      isYes = option: {
        assertion = config: config.isYes option;
        message = "CONFIG_${option} is not yes!";
        configLine = "CONFIG_${option}=y";
      };

      isNo = option: {
        assertion = config: config.isNo option;
        message = "CONFIG_${option} is not no!";
        configLine = "CONFIG_${option}=n";
      };

      isModule = option: {
        assertion = config: config.isModule option;
        message = "CONFIG_${option} is not built as a module!";
        configLine = "CONFIG_${option}=m";
      };

      ### Usually you will just want to use these two
      # True if yes or module
      isEnabled = option: {
        assertion = config: config.isEnabled option;
        message = "CONFIG_${option} is not enabled!";
        configLine = "CONFIG_${option}=y";
      };

      # True if no or omitted
      isDisabled = option: {
        assertion = config: config.isDisabled option;
        message = "CONFIG_${option} is not disabled!";
        configLine = "CONFIG_${option}=n";
      };
    };

    # The config options that all modules can depend upon
    system.requiredKernelConfig = with config.lib.kernelConfig; [
      # !!! Should this really be needed?
      (isYes "MODULES")
      (isYes "BINFMT_ELF")
    ];

    # nixpkgs kernels are assumed to have all required features
    assertions = if config.boot.kernelPackages.kernel ? features then [] else
      let cfg = config.boot.kernelPackages.kernel.config; in map (attrs:
        { assertion = attrs.assertion cfg; inherit (attrs) message; }
      ) config.system.requiredKernelConfig;

  };

}
