{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.boot.loader.grub;

  realGrub = if cfg.version == 1 then pkgs.grub
    else pkgs.grub2.override { zfsSupport = cfg.zfsSupport; };

  grub =
    # Don't include GRUB if we're only generating a GRUB menu (e.g.,
    # in EC2 instances).
    if cfg.devices == ["nodev"]
    then null
    else realGrub;

  f = x: if x == null then "" else "" + x;

  grubConfig = pkgs.writeText "grub-config.xml" (builtins.toXML
    { splashImage = f config.boot.loader.grub.splashImage;
      grub = f grub;
      shell = "${pkgs.stdenv.shell}";
      fullVersion = (builtins.parseDrvName realGrub.name).version;
      inherit (cfg)
        version extraConfig extraPerEntryConfig extraEntries
        extraEntriesBeforeNixOS extraPrepareConfig configurationLimit copyKernels timeout
        default devices fsIdentifier;
      path = (makeSearchPath "bin" [
        pkgs.coreutils pkgs.gnused pkgs.gnugrep pkgs.findutils pkgs.diffutils pkgs.btrfsProgs
        pkgs.utillinux
      ]) + ":" + (makeSearchPath "sbin" [
        pkgs.mdadm pkgs.utillinux
      ]);
    });

in

{

  ###### interface

  options = {

    boot.loader.grub = {

      enable = mkOption {
        default = !config.boot.isContainer;
        type = types.bool;
        description = ''
          Whether to enable the GNU GRUB boot loader.
        '';
      };

      version = mkOption {
        default = 2;
        example = 1;
        type = types.int;
        description = ''
          The version of GRUB to use: <literal>1</literal> for GRUB
          Legacy (versions 0.9x), or <literal>2</literal> (the
          default) for GRUB 2.
        '';
      };

      device = mkOption {
        default = "";
        example = "/dev/hda";
        type = types.str;
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
        type = types.listOf types.str;
        description = ''
          The devices on which the boot loader, GRUB, will be
          installed. Can be used instead of <literal>device</literal> to
          install grub into multiple devices (e.g., if as softraid arrays holding /boot).
        '';
      };

      configurationName = mkOption {
        default = "";
        example = "Stable 2.6.21";
        type = types.str;
        description = ''
          GRUB entry name instead of default.
        '';
      };

      extraPrepareConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Additional bash commands to be run at the script that
          prepares the grub menu entries.
        '';
      };

      extraConfig = mkOption {
        default = "";
        example = "serial; terminal_output.serial";
        type = types.lines;
        description = ''
          Additional GRUB commands inserted in the configuration file
          just before the menu entries.
        '';
      };

      extraPerEntryConfig = mkOption {
        default = "";
        example = "root (hd0)";
        type = types.lines;
        description = ''
          Additional GRUB commands inserted in the configuration file
          at the start of each NixOS menu entry.
        '';
      };

      extraEntries = mkOption {
        default = "";
        type = types.lines;
        example = ''
          # GRUB 1 example (not GRUB 2 compatible)
          title Windows
            chainloader (hd0,1)+1

          # GRUB 2 example
          menuentry "Windows 7" {
            chainloader (hd0,4)+1
          }
        '';
        description = ''
          Any additional entries you want added to the GRUB boot menu.
        '';
      };

      extraEntriesBeforeNixOS = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether extraEntries are included before the default option.
        '';
      };

      extraFiles = mkOption {
        default = {};
        example = literalExample ''
          { "memtest.bin" = "''${pkgs.memtest86plus}/memtest.bin"; }
        '';
        description = ''
          A set of files to be copied to <filename>/boot</filename>.
          Each attribute name denotes the destination file name in
          <filename>/boot</filename>, while the corresponding
          attribute value specifies the source file.
        '';
      };

      splashImage = mkOption {
        example = literalExample "./my-background.png";
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
        type = types.int;
        description = ''
          Maximum of configurations in boot menu. GRUB has problems when
          there are too many entries.
        '';
      };

      copyKernels = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether the GRUB menu builder should copy kernels and initial
          ramdisks to /boot.  This is done automatically if /boot is
          on a different partition than /.
        '';
      };

      timeout = mkOption {
        default = 5;
        type = types.int;
        description = ''
          Timeout (in seconds) until GRUB boots the default menu item.
        '';
      };

      default = mkOption {
        default = 0;
        type = types.int;
        description = ''
          Index of the default menu item to be booted.
        '';
      };

      fsIdentifier = mkOption {
        default = "uuid";
        type = types.addCheck types.str
          (type: type == "uuid" || type == "label" || type == "provided");
        description = ''
          Determines how grub will identify devices when generating the
          configuration file. A value of uuid / label signifies that grub
          will always resolve the uuid or label of the device before using
          it in the configuration. A value of provided means that grub will
          use the device name as show in <command>df</command> or
          <command>mount</command>. Note, zfs zpools / datasets are ignored
          and will always be mounted using their labels.
        '';
      };

      zfsSupport = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether grub should be build against libzfs.
        '';
      };

      enableCryptodisk = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Enable support for encrypted partitions. Grub should automatically
          unlock the correct encrypted partition and look for filesystems.
        '';
      };

    };

  };


  ###### implementation

  config = mkMerge [

    { boot.loader.grub.splashImage = mkDefault (
        if cfg.version == 1 then pkgs.fetchurl {
          url = http://www.gnome-look.org/CONTENT/content-files/36909-soft-tux.xpm.gz;
          sha256 = "14kqdx2lfqvh40h6fjjzqgff1mwk74dmbjvmqphi6azzra7z8d59";
        }
        # GRUB 1.97 doesn't support gzipped XPMs.
        else ./winkler-gnu-blue-640x480.png);
    }

    (mkIf cfg.enable {

      boot.loader.grub.devices = optional (cfg.device != "") cfg.device;

      system.build.installBootLoader =
        if cfg.devices == [] then
          throw "You must set the option ‘boot.loader.grub.device’ to make the system bootable."
        else
          "PERL5LIB=${makePerlPath (with pkgs.perlPackages; [ FileSlurp XMLLibXML XMLSAX ])} " +
          (if cfg.enableCryptodisk then "GRUB_ENABLE_CRYPTODISK=y " else "") +
          "${pkgs.perl}/bin/perl ${./install-grub.pl} ${grubConfig}";

      system.build.grub = grub;

      # Common attribute for boot loaders so only one of them can be
      # set at once.
      system.boot.loader.id = "grub";

      environment.systemPackages = optional (grub != null) grub;

      boot.loader.grub.extraPrepareConfig =
        concatStrings (mapAttrsToList (n: v: ''
          ${pkgs.coreutils}/bin/cp -pf "${v}" "/boot/${n}"
        '') config.boot.loader.grub.extraFiles);

    assertions = [{ assertion = !cfg.zfsSupport || cfg.version == 2;
                    message = "Only grub version 2 provides zfs support";}]
      ++ flip map cfg.devices (dev: {
        assertion = dev == "nodev" || hasPrefix "/" dev;
        message = "Grub devices must be absolute paths, not ${dev}";
      });

    })

  ];

}
