{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.boot.loader.grub;

  grub = if cfg.version == 1 then pkgs.grub else pkgs.grub2;

  grubMenuBuilder = pkgs.substituteAll {
    src = ./grub-menu-builder.sh;
    isExecutable = true;
    inherit grub;
    inherit (pkgs) bash;
    path = [pkgs.coreutils pkgs.gnused pkgs.gnugrep];
    inherit (config.boot.loader.grub) copyKernels extraPrepareConfig
      extraConfig extraEntries extraEntriesBeforeNixOS extraPerEntryConfig
      splashImage configurationLimit version default timeout;
  };

in

{

  ###### interface

  options = {

    boot.loader.grub = {

      enable = mkOption {
        default = true;
        description = ''
          Whether to enable the GNU GRUB boot loader.
        '';
      };

      version = mkOption {
        default = 1;
        example = 2;
        description = ''
          The version of GRUB to use: <literal>1</literal> for GRUB Legacy
          (versions 0.9x), or <literal>2</literal> for GRUB 2.
        '';
      };

      device = mkOption {
        default = "";
        example = "/dev/hda";
        type = with pkgs.lib.types; uniq string;
        description = ''
          The device on which the GRUB boot loader will be installed.
          The special value <literal>nodev</literal> means that a GRUB
          boot menu will be generated, but GRUB itself will not
          actually be installed.  To install GRUB on multiple devices,
          use <literal>boot.loader.grub.devices</literal>.
        '';
      };

      devices = mkOption {
        default = [];
        example = [ "/dev/hda" ];
        type = with pkgs.lib.types; listOf string;
        description = ''
          The devices on which the boot loader, GRUB, will be
          installed. Can be used instead of <literal>device</literal> to
          install grub into multiple devices (e.g., if as softraid arrays holding /boot).
        '';
      };

      # !!! How can we mark options as obsolete?
      bootDevice = mkOption {
        default = "";
        description = "Obsolete.";
      };

      configurationName = mkOption {
        default = "";
        example = "Stable 2.6.21";
        description = ''
          GRUB entry name instead of default.
        '';
      };

      extraPrepareConfig = mkOption {
        default = "";
        description = ''
          Additional bash commands to be run at the script that
          prepares the grub menu entries.
        '';
      };

      extraConfig = mkOption {
        default = "";
        example = "serial; terminal_output.serial";
        description = ''
          Additional GRUB commands inserted in the configuration file
          just before the menu entries.
        '';
      };

      extraPerEntryConfig = mkOption {
        default = "";
        example = "root (hd0)";
        description = ''
          Additional GRUB commands inserted in the configuration file
          at the start of each NixOS menu entry.
        '';
      };

      extraEntries = mkOption {
        default = "";
        example = ''
          # GRUB 1 example (not GRUB 2 compatible)
          title Windows
            chainloader (hd0,1)+1

          # GRUB 2 example
          menuentry "Windows7" {
            title Windows7
            insmod ntfs
            set root='(hd1,1)'
            chainloader +1
          }
        '';
        description = ''
          Any additional entries you want added to the GRUB boot menu.
        '';
      };

      extraEntriesBeforeNixOS = mkOption {
        default = false;
        description = ''
          Whether extraEntries are included before the default option.
        '';
      };

      ignoreDevicesCheck = mkOption {
        default = false;
        description = ''
          (internal use) Don't throw an error when devices aren't given
          useful for building nested child configurations
        '';
      };

      splashImage = mkOption {
        default =
          if config.boot.loader.grub.version == 1
          then pkgs.fetchurl {
            url = http://www.gnome-look.org/CONTENT/content-files/36909-soft-tux.xpm.gz;
            sha256 = "14kqdx2lfqvh40h6fjjzqgff1mwk74dmbjvmqphi6azzra7z8d59";
          }
          # GRUB 1.97 doesn't support gzipped XPMs.
          else ./winkler-gnu-blue-640x480.png;
        example = null;
        description = ''
          Background image used for GRUB.  It must be a 640x480,
          14-colour image in XPM format, optionally compressed with
          <command>gzip</command> or <command>bzip2</command>.  Set to
          <literal>null</literal> to run GRUB in text mode.
        '';
      };

      configurationLimit = mkOption {
        default = 100;
        example = 120;
        description = ''
          Maximum of configurations in boot menu. GRUB has problems when
          there are too many entries.
        '';
      };

      copyKernels = mkOption {
        default = false;
        description = ''
          Whether the GRUB menu builder should copy kernels and initial
          ramdisks to /boot.  This is done automatically if /boot is
          on a different partition than /.
        '';
      };

      timeout = mkOption {
        default = 5;
        description = ''
          Timeout (in seconds) until GRUB boots the default menu item.
        '';
      };

      default = mkOption {
        default = 0;
        description = ''
          Index of the default menu item to be booted.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.boot.loader.grub.enable {

    boot.loader.grub.devices = optional (cfg.device != "") cfg.device;

    system.build = mkAssert (cfg.devices != [] || cfg.ignoreDevicesCheck)
      "You must set the ‘boot.loader.grub.device’ option to make the system bootable."
      { menuBuilder = grubMenuBuilder;
        inherit grub;
      };

    # Common attribute for boot loaders so only one of them can be
    # set at once.
    system.boot.loader.id = "grub";
    system.boot.loader.kernelFile = pkgs.stdenv.platform.kernelTarget;

    environment.systemPackages = mkIf config.boot.loader.grub.enable [ grub ];

  };

}
