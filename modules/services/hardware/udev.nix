{pkgs, config, ...}:

with pkgs.lib;

let

  inherit (pkgs) stdenv writeText udev procps;

  cfg = config.services.udev;

  extraUdevRules = pkgs.writeTextFile {
    name = "extra-udev-rules";
    text = cfg.extraRules;
    destination = "/etc/udev/rules.d/10-local.rules";
  };

  modprobe = config.system.sbin.modprobe;
    
  nixosRules = ''
  
    # Miscellaneous devices.
    KERNEL=="sonypi",               MODE="0666"
    KERNEL=="kvm",                  MODE="0666"
    KERNEL=="kqemu",                MODE="0666"
    KERNEL=="vboxdrv",  NAME="vboxdrv",  OWNER="root", GROUP="root", MODE="0666"
    KERNEL=="vboxadd",  NAME="vboxadd",  OWNER="root", GROUP="root", MODE="0660"
    KERNEL=="vboxuser", NAME="vboxuser", OWNER="root", GROUP="root", MODE="0666"
  '';
  
  # Perform substitutions in all udev rules files.
  udevRules = stdenv.mkDerivation {
    name = "udev-rules";
    buildCommand = ''
      ensureDir $out
      shopt -s nullglob

      # Use all the default udev rules.
      cp -v ${udev}/libexec/rules.d/*.rules $out/

      # Set a reasonable $PATH for programs called by udev rules.
      echo 'ENV{PATH}="${pkgs.coreutils}/bin:${pkgs.gnused}/bin:${pkgs.utillinux}/bin"' > $out/00-path.rules

      # Set the firmware search path so that the firmware.sh helper
      # called by 50-firmware.rules works properly.
      echo 'ENV{FIRMWARE_DIRS}="/root/test-firmware ${toString config.hardware.firmware}"' >> $out/00-path.rules
      
      # Add the udev rules from other packages.
      for i in ${toString cfg.packages}; do
        echo "Add rules for package $i"
        for j in $i/*/udev/rules.d/*; do
          ln -sv $j $out/$(basename $j)
        done
      done

      # Fix some paths in the standard udev rules.  Hacky.
      for i in $out/*.rules; do
        substituteInPlace $i \
          --replace /sbin/modprobe ${modprobe}/sbin/modprobe \
          --replace /sbin/blkid ${pkgs.utillinux}/sbin/blkid \
          --replace /sbin/mdadm ${pkgs.mdadm}/sbin/mdadm \
          --replace '$env{DM_SBIN_PATH}/blkid' ${pkgs.utillinux}/sbin/blkid \
          --replace 'ENV{DM_SBIN_PATH}="/sbin"' 'ENV{DM_SBIN_PATH}="${pkgs.lvm2}/sbin"'
      done

      # If auto-configuration is disabled, then remove
      # udev's 80-drivers.rules file, which contains rules for
      # automatically calling modprobe.
      ${if !config.boot.hardwareScan then "rm $out/80-drivers.rules" else ""}

      # Use the persistent device rules (naming for CD/DVD and
      # network devices) stored in 
      # /var/lib/udev/rules.d/70-persistent-{cd,net}.rules.  These are
      # modified by the write_{cd,net}_rules helpers called from
      # 75-cd-aliases-generator.rules and
      # 75-persistent-net-generator.rules.
      ln -sv /var/lib/udev/rules.d/70-persistent-cd.rules $out/
      ln -sv /var/lib/udev/rules.d/70-persistent-net.rules $out/
    ''; # */
  };

  # The udev configuration file.
  conf = writeText "udev.conf" ''
    udev_rules="${udevRules}"
    #udev_log="debug"
  '';

in

{

  ###### interface
  
  options = {

    boot.hardwareScan = mkOption {
      default = true;
      description = ''
        Whether to try to load kernel modules for all detected hardware.
        Usually this does a good job of providing you with the modules
        you need, but sometimes it can crash the system or cause other
        nasty effects.  If the hardware scan is turned on, it can be
        disabled at boot time by adding the <literal>safemode</literal>
        parameter to the kernel command line.
      '';
    };
  
    services.udev = {

      packages = mkOption {
        default = [];
        merge = mergeListOption;
        description = ''
          List of packages containing <command>udev</command> rules.
          All files found in
          <filename><replaceable>pkg</replaceable>/etc/udev/rules.d</filename> and
          <filename><replaceable>pkg</replaceable>/lib/udev/rules.d</filename>
          will be included.
        '';
      };

      extraRules = mkOption {
        default = "";
        example = ''
          KERNEL=="eth*", ATTR{address}=="00:1D:60:B9:6D:4F", NAME="my_fast_network_card"
        '';
        merge = mergeStringOption;
        description = ''
          Additional <command>udev</command> rules. They'll be written
          into file <filename>10-local.rules</filename>. Thus they are
          read before all other rules.
        '';
      };

    };
    
    hardware.firmware = mkOption {
      default = [];
      example = [/root/my-firmware];
      merge = mergeListOption; 
      description = ''
        List of directories containing firmware files.  Such files
        will be loaded automatically if the kernel asks for them
        (i.e., when it has detected specific hardware that requires
        firmware to function).
      '';
      apply = list: pkgs.buildEnv {
        name = "firmware";
        paths = list;
        pathsToLink = [ "/" ];
      };
    };
    
  };
  

  ###### implementation

  config = {

    services.udev.extraRules = nixosRules;
    
    services.udev.packages = [extraUdevRules];

    jobs.udev =
      { startOn = "startup";

        environment = { UDEV_CONFIG_FILE = conf; };

        preStart =
          ''
            echo "" > /proc/sys/kernel/hotplug

            mkdir -p /var/lib/udev/rules.d

            # Do the loading of additional stage 2 kernel modules.
            # Maybe this isn't the best place...
            for i in ${toString config.boot.kernelModules}; do
                echo "Loading kernel module $i..."
                ${modprobe}/sbin/modprobe $i || true
            done

            mkdir -p /dev/.udev # !!! bug in udev?
          '';

        daemonType = "fork";

        exec = "${udev}/sbin/udevd --daemon";
      };

    jobs.udevtrigger =
      { startOn = "started udev";

        task = true;

        script =
          ''
            # Let udev create device nodes for all modules that have already
            # been loaded into the kernel (or for which support is built into
            # the kernel).  The `STARTUP' variable is needed to force
            # the LVM rules to create device nodes.  See
            # http://www.mail-archive.com/fedora-devel-list@redhat.com/msg10261.html
            ${udev}/sbin/udevadm control --env=STARTUP=1
            ${udev}/sbin/udevadm trigger --action=add
            ${udev}/sbin/udevadm settle # wait for udev to finish
            ${udev}/sbin/udevadm control --env=STARTUP=

            initctl emit -n new-devices
          '';
      };
      
  };

}
