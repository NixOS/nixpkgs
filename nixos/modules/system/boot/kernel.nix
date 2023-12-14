{ config, lib, pkgs, ... }:

with lib;

let

  inherit (config.boot) kernelPatches;
  inherit (config.boot.kernel) features randstructSeed;
  inherit (config.boot.kernelPackages) kernel;

  kernelModulesConf = pkgs.writeText "nixos.conf"
    ''
      ${concatStringsSep "\n" config.boot.kernelModules}
    '';

in

{

  ###### interface

  options = {
    boot.kernel.enable = mkEnableOption (lib.mdDoc "the Linux kernel. This is useful for systemd-like containers which do not require a kernel") // {
      default = true;
    };

    boot.kernel.features = mkOption {
      default = {};
      example = literalExpression "{ debug = true; }";
      internal = true;
      description = lib.mdDoc ''
        This option allows to enable or disable certain kernel features.
        It's not API, because it's about kernel feature sets, that
        make sense for specific use cases. Mostly along with programs,
        which would have separate nixos options.
        `grep features pkgs/os-specific/linux/kernel/common-config.nix`
      '';
    };

    boot.kernelPackages = mkOption {
      default = pkgs.linuxPackages;
      type = types.raw;
      apply = kernelPackages: kernelPackages.extend (self: super: {
        kernel = super.kernel.override (originalArgs: {
          inherit randstructSeed;
          kernelPatches = (originalArgs.kernelPatches or []) ++ kernelPatches;
          features = lib.recursiveUpdate super.kernel.features features;
        });
      });
      # We don't want to evaluate all of linuxPackages for the manual
      # - some of it might not even evaluate correctly.
      defaultText = literalExpression "pkgs.linuxPackages";
      example = literalExpression "pkgs.linuxKernel.packages.linux_5_10";
      description = lib.mdDoc ''
        This option allows you to override the Linux kernel used by
        NixOS.  Since things like external kernel module packages are
        tied to the kernel you're using, it also overrides those.
        This option is a function that takes Nixpkgs as an argument
        (as a convenience), and returns an attribute set containing at
        the very least an attribute {var}`kernel`.
        Additional attributes may be needed depending on your
        configuration.  For instance, if you use the NVIDIA X driver,
        then it also needs to contain an attribute
        {var}`nvidia_x11`.

        Please note that we strictly support kernel versions that are
        maintained by the Linux developers only. More information on the
        availability of kernel versions is documented
        [in the Linux section of the manual](https://nixos.org/manual/nixos/unstable/index.html#sec-kernel-config).
      '';
    };

    boot.kernelPatches = mkOption {
      type = types.listOf types.attrs;
      default = [];
      example = literalExpression ''
        [
          {
            name = "foo";
            patch = ./foo.patch;
            extraStructuredConfig.FOO = lib.kernel.yes;
            features.foo = true;
          }
        ]
      '';
      description = lib.mdDoc ''
        A list of additional patches to apply to the kernel.

        Every item should be an attribute set with the following attributes:

        ```nix
        {
          name = "foo";                 # descriptive name, required

          patch = ./foo.patch;          # path or derivation that contains the patch source
                                        # (required, but can be null if only config changes
                                        # are needed)

          extraStructuredConfig = {     # attrset of extra configuration parameters without the CONFIG_ prefix
            FOO = lib.kernel.yes;       # (optional)
          };                            # values should generally be lib.kernel.yes,
                                        # lib.kernel.no or lib.kernel.module

          features = {                  # attrset of extra "features" the kernel is considered to have
            foo = true;                 # (may be checked by other NixOS modules, optional)
          };

          extraConfig = "FOO y";        # extra configuration options in string form without the CONFIG_ prefix
                                        # (optional, multiple lines allowed to specify multiple options)
                                        # (deprecated, use extraStructuredConfig instead)
        }
        ```

        There's a small set of existing kernel patches in Nixpkgs, available as `pkgs.kernelPatches`,
        that follow this format and can be used directly.
      '';
    };

    boot.kernel.randstructSeed = mkOption {
      type = types.str;
      default = "";
      example = "my secret seed";
      description = lib.mdDoc ''
        Provides a custom seed for the {var}`RANDSTRUCT` security
        option of the Linux kernel. Note that {var}`RANDSTRUCT` is
        only enabled in NixOS hardened kernels. Using a custom seed requires
        building the kernel and dependent packages locally, since this
        customization happens at build time.
      '';
    };

    boot.kernelParams = mkOption {
      type = types.listOf (types.strMatching ''([^"[:space:]]|"[^"]*")+'' // {
        name = "kernelParam";
        description = "string, with spaces inside double quotes";
      });
      default = [ ];
      description = lib.mdDoc "Parameters added to the kernel command line.";
    };

    boot.consoleLogLevel = mkOption {
      type = types.int;
      default = 4;
      description = lib.mdDoc ''
        The kernel console `loglevel`. All Kernel Messages with a log level smaller
        than this setting will be printed to the console.
      '';
    };

    boot.vesa = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        (Deprecated) This option, if set, activates the VESA 800x600 video
        mode on boot and disables kernel modesetting. It is equivalent to
        specifying `[ "vga=0x317" "nomodeset" ]` in the
        {option}`boot.kernelParams` option. This option is
        deprecated as of 2020: Xorg now works better with modesetting, and
        you might want a different VESA vga setting, anyway.
      '';
    };

    boot.extraModulePackages = mkOption {
      type = types.listOf types.package;
      default = [];
      example = literalExpression "[ config.boot.kernelPackages.nvidia_x11 ]";
      description = lib.mdDoc "A list of additional packages supplying kernel modules.";
    };

    boot.kernelModules = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
        The set of kernel modules to be loaded in the second stage of
        the boot process.  Note that modules that are needed to
        mount the root file system should be added to
        {option}`boot.initrd.availableKernelModules` or
        {option}`boot.initrd.kernelModules`.
      '';
    };

    boot.initrd.availableKernelModules = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "sata_nv" "ext3" ];
      description = lib.mdDoc ''
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
        include it in {option}`boot.initrd.kernelModules`.
      '';
    };

    boot.initrd.kernelModules = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc "List of modules that are always loaded by the initrd.";
    };

    boot.initrd.includeDefaultModules = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        This option, if set, adds a collection of default kernel modules
        to {option}`boot.initrd.availableKernelModules` and
        {option}`boot.initrd.kernelModules`.
      '';
    };

    system.modulesTree = mkOption {
      type = types.listOf types.path;
      internal = true;
      default = [];
      description = lib.mdDoc ''
        Tree of kernel modules.  This includes the kernel, plus modules
        built outside of the kernel.  Combine these into a single tree of
        symlinks because modprobe only supports one directory.
      '';
      # Convert the list of path to only one path.
      apply = pkgs.aggregateModules;
    };

    system.requiredKernelConfig = mkOption {
      default = [];
      example = literalExpression ''
        with config.lib.kernelConfig; [
          (isYes "MODULES")
          (isEnabled "FB_CON_DECOR")
          (isEnabled "BLK_DEV_INITRD")
        ]
      '';
      internal = true;
      type = types.listOf types.attrs;
      description = lib.mdDoc ''
        This option allows modules to specify the kernel config options that
        must be set (or unset) for the module to work. Please use the
        lib.kernelConfig functions to build list elements.
      '';
    };

  };


  ###### implementation

  config = mkMerge
    [ (mkIf config.boot.initrd.enable {
        boot.initrd.availableKernelModules =
          optionals config.boot.initrd.includeDefaultModules ([
            # Note: most of these (especially the SATA/PATA modules)
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

            # NVMe
            "nvme"

            # Standard SCSI stuff.
            "sd_mod"
            "sr_mod"

            # SD cards and internal eMMC drives.
            "mmc_block"

            # Support USB keyboards, in case the boot fails and we only have
            # a USB keyboard, or for LUKS passphrase prompt.
            "uhci_hcd"
            "ehci_hcd"
            "ehci_pci"
            "ohci_hcd"
            "ohci_pci"
            "xhci_hcd"
            "xhci_pci"
            "usbhid"
            "hid_generic" "hid_lenovo" "hid_apple" "hid_roccat"
            "hid_logitech_hidpp" "hid_logitech_dj" "hid_microsoft" "hid_cherry"

          ] ++ optionals pkgs.stdenv.hostPlatform.isx86 [
            # Misc. x86 keyboard stuff.
            "pcips2" "atkbd" "i8042"

            # x86 RTC needed by the stage 2 init script.
            "rtc_cmos"
          ]);

        boot.initrd.kernelModules =
          optionals config.boot.initrd.includeDefaultModules [
            # For LVM.
            "dm_mod"
          ];
      })

      (mkIf config.boot.kernel.enable {
        system.build = { inherit kernel; };

        system.modulesTree = [ kernel ] ++ config.boot.extraModulePackages;

        # Not required for, e.g., containers as they don't have their own kernel or initrd.
        # They boot directly into stage 2.
        system.systemBuilderArgs.kernelParams = config.boot.kernelParams;
        system.systemBuilderCommands =
          let
            kernelPath = "${config.boot.kernelPackages.kernel}/" +
              "${config.system.boot.loader.kernelFile}";
            initrdPath = "${config.system.build.initialRamdisk}/" +
              "${config.system.boot.loader.initrdFile}";
          in
          ''
            if [ ! -f ${kernelPath} ]; then
              echo "The bootloader cannot find the proper kernel image."
              echo "(Expecting ${kernelPath})"
              false
            fi

            ln -s ${kernelPath} $out/kernel
            ln -s ${config.system.modulesTree} $out/kernel-modules
            ${optionalString (config.hardware.deviceTree.package != null) ''
              ln -s ${config.hardware.deviceTree.package} $out/dtbs
            ''}

            echo -n "$kernelParams" > $out/kernel-params

            ln -s ${initrdPath} $out/initrd

            ln -s ${config.system.build.initialRamdiskSecretAppender}/bin/append-initrd-secrets $out

            ln -s ${config.hardware.firmware}/lib/firmware $out/firmware
          '';

        # Implement consoleLogLevel both in early boot and using sysctl
        # (so you don't need to reboot to have changes take effect).
        boot.kernelParams =
          [ "loglevel=${toString config.boot.consoleLogLevel}" ] ++
          optionals config.boot.vesa [ "vga=0x317" "nomodeset" ];

        boot.kernel.sysctl."kernel.printk" = mkDefault config.boot.consoleLogLevel;

        boot.kernelModules = [ "loop" "atkbd" ];

        # Create /etc/modules-load.d/nixos.conf, which is read by
        # systemd-modules-load.service to load required kernel modules.
        environment.etc =
          { "modules-load.d/nixos.conf".source = kernelModulesConf;
          };

        systemd.services.systemd-modules-load =
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
        system.requiredKernelConfig = with config.lib.kernelConfig;
          [
            # !!! Should this really be needed?
            (isYes "MODULES")
            (isYes "BINFMT_ELF")
          ] ++ (optional (randstructSeed != "") (isYes "GCC_PLUGIN_RANDSTRUCT"));

        # nixpkgs kernels are assumed to have all required features
        assertions = if config.boot.kernelPackages.kernel ? features then [] else
          let cfg = config.boot.kernelPackages.kernel.config; in map (attrs:
            { assertion = attrs.assertion cfg; inherit (attrs) message; }
          ) config.system.requiredKernelConfig;

      })

    ];

}
