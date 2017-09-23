{ config, lib, pkgs, ... }:

with lib;

let

  inherit (config.boot) kernelPatches;

  inherit (config.boot.kernelPackages) kernel;

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
      apply = kernelPackages: kernelPackages.extend (self: super: {
        kernel = super.kernel.override {
          kernelPatches = super.kernel.kernelPatches ++ kernelPatches;
        };
      });
      # We don't want to evaluate all of linuxPackages for the manual
      # - some of it might not even evaluate correctly.
      defaultText = "pkgs.linuxPackages";
      example = literalExample "pkgs.linuxPackages_2_6_25";
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

    boot.kernelPatches = mkOption {
      type = types.listOf types.attrs;
      default = [];
      example = literalExample "[ pkgs.kernelPatches.ubuntu_fan_4_4 ]";
      description = "A list of additional patches to apply to the kernel.";
    };

    boot.kernelParams = mkOption {
      type = let
        coerce = list: let
          mkItem = item: let
            splitted = builtins.match "([^=]*)=(.*)" item;
          in if splitted == null then nameValuePair item true
             else nameValuePair (head splitted) (last splitted);
        in listToAttrs (map mkItem list);
        targetType = with types; attrsOf (either (either bool int) str);
      in with types; coercedTo (listOf str) coerce targetType;
      default = {};
      example = {
        acpi_apic_instance = 2;
        tmem = true;
        nf_conntrack.acct = 1;
        acpi_osi = "Windows 2000";
      };
      description = let
        docUrl = "https://www.kernel.org/doc/html/latest/admin-guide/"
               + "kernel-parameters.html";
      in ''
        An attribute set of kernel command line paramaters, where the attribute
        name denotes a particular parameter. If the attribute value is
        <literal>true</literal> the attribute name is passed verbatim and if
        it's <literal>false</literal> the parameter is dropped entirely.

        Have a look at the <link xlink:href="${docUrl}">documentation</link>
        for possible values.
      '';
    };

    boot.initArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "--crash-shell" "--crash-vt=1" ];
      description = ''
        Arguments passed to <citerefentry>
          <refentrytitle>init</refentrytitle>
          <manvolnum>1</manvolnum>
        </citerefentry> via kernel parameters.

        You could directly use <option>boot.kernelParams</option> to do the
        same thing, but if there are collisions with existing kernel parameters
        it's very likely that the init argument is silently ignored.

        Furthermore, passing init arguments via
        <option>boot.kernelParams</option> will cause the arguments to be
        sorted, so it's unsuitable if you use an init that depends on the order
        of arguments.
      '';
    };

    boot.kernelParamList = mkOption {
      type = types.listOf types.str;
      default = let
        enabled = filterAttrs (const (v: v != false)) config.boot.kernelParams;
        hasSpace = val: builtins.match ".* .*" val != null;
        mkStrVal = val: if hasSpace val then "\"${val}\"" else val;
        mkItem = key: val: if val == true then key
                           else "${key}=${mkStrVal (toString val)}";
        initArgSep = optional (config.boot.initArgs != []) "--";
      in mapAttrsToList mkItem enabled ++ initArgSep ++ config.boot.initArgs;
      internal = true;
      readOnly = true;
      description = ''
        Kernel command line parameters provided as a list.

        This option is only for internal purposes if you want to get the values
        of <option>boot.kernelParams</option> as a list of strings with proper
        quoting and handling of boolean options.
      '';
    };

    boot.consoleLogLevel = mkOption {
      type = types.int;
      default = 4;
      description = ''
        The kernel console log level.  Log messages with a priority
        numerically less than this will not appear on the console.
      '';
    };

    boot.vesa = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to activate VESA video mode on boot.
      '';
    };

    boot.extraModulePackages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExample "[ pkgs.linuxPackages.nvidia_x11 ]";
      description = "A list of additional packages supplying kernel modules.";
    };

    boot.kernelModules = mkOption {
      type = types.listOf types.str;
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
      type = types.listOf types.str;
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
      type = types.listOf types.str;
      default = [];
      description = "List of modules that are always loaded by the initrd.";
    };

    system.modulesTree = mkOption {
      type = types.listOf types.path;
      internal = true;
      default = [];
      description = ''
        Tree of kernel modules.  This includes the kernel, plus modules
        built outside of the kernel.  Combine these into a single tree of
        symlinks because modprobe only supports one directory.
      '';
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

  config = mkIf (!config.boot.isContainer) {

    system.build = { inherit kernel; };

    system.modulesTree = [ kernel ] ++ config.boot.extraModulePackages;

    # Implement consoleLogLevel both in early boot and using sysctl
    # (so you don't need to reboot to have changes take effect).
    boot.kernelParams =
      [ "loglevel=${toString config.boot.consoleLogLevel}" ] ++
      optionals config.boot.vesa [ "vga=0x317" ];

    boot.kernel.sysctl."kernel.printk" = config.boot.consoleLogLevel;

    boot.kernelModules = [ "loop" "atkbd" ];

    boot.initrd.availableKernelModules =
      [ # Note: most of these (especially the SATA/PATA modules)
        # shouldn't be included by default since nixos-generate-config
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

        # SD cards and internal eMMC drives.
        "mmc_block"

        # Support USB keyboards, in case the boot fails and we only have
        # a USB keyboard.
        "uhci_hcd"
        "ehci_hcd"
        "ehci_pci"
        "ohci_hcd"
        "ohci_pci"
        "xhci_hcd"
        "xhci_pci"
        "usbhid"
        "hid_generic" "hid_lenovo"
        "hid_apple" "hid_logitech_dj" "hid_lenovo_tpkbd" "hid_roccat"

        # Misc. keyboard stuff.
        "pcips2" "atkbd" "i8042"

        # Temporary fix for https://github.com/NixOS/nixpkgs/issues/18451
        # Remove as soon as upstream gets fixed - marking it:
        # TODO
        # FIXME
        "i8042"

        # To wait for SCSI devices to appear.
        "scsi_wait_scan"

        # Needed by the stage 2 init script.
        "rtc_cmos"
      ];

    boot.initrd.kernelModules =
      [ # For LVM.
        "dm_mod"
      ];

    # The Linux kernel >= 2.6.27 provides firmware.
    hardware.firmware = [ kernel ];

    # Create /etc/modules-load.d/nixos.conf, which is read by
    # systemd-modules-load.service to load required kernel modules.
    environment.etc = singleton
      { target = "modules-load.d/nixos.conf";
        source = kernelModulesConf;
      };

    systemd.services."systemd-modules-load" =
      { wantedBy = [ "multi-user.target" ];
        restartTriggers = [ kernelModulesConf ];
        serviceConfig =
          { # Ignore failed module loads.  Typically some of the
            # modules in ‘boot.kernelModules’ are "nice to have but
            # not required" (e.g. acpi-cpufreq), so we don't want to
            # barf on those.
            SuccessExitStatus = "0 1";
          };
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
