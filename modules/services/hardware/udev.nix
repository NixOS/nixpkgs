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
    KERNEL=="kqemu",                NAME="%k", MODE="0666"
    KERNEL=="vboxdrv", NAME="vboxdrv", OWNER="root", GROUP="root", MODE="0666"

    # Create symlinks for CD/DVD devices.
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_CDROM}=="?*", SYMLINK+="cdrom cdrom-%k"
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_CDROM_CD_RW}=="?*", SYMLINK+="cdrw cdrw-%k"
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_CDROM_DVD}=="?*", SYMLINK+="dvd dvd-%k"
    ACTION=="add", SUBSYSTEM=="block", ENV{ID_CDROM_DVD_RW}=="?*", SYMLINK+="dvdrw dvdrw-%k"
    
    # ALSA sound devices.
    KERNEL=="controlC[0-9]*",       NAME="snd/%k", MODE="${cfg.sndMode}"
    KERNEL=="hwC[D0-9]*",           NAME="snd/%k", MODE="${cfg.sndMode}"
    KERNEL=="pcmC[D0-9cp]*",        NAME="snd/%k", MODE="${cfg.sndMode}"
    KERNEL=="midiC[D0-9]*",         NAME="snd/%k", MODE="${cfg.sndMode}"
    KERNEL=="timer",                NAME="snd/%k", MODE="${cfg.sndMode}"
    KERNEL=="seq",                  NAME="snd/%k", MODE="${cfg.sndMode}"

  '';
  
  # Perform substitutions in all udev rules files.
  udevRules = stdenv.mkDerivation {
    name = "udev-rules";
    #src = cleanSource ./udev-rules;
    buildCommand = ''
      ensureDir $out
      shopt -s nullglob

      # Use all the default udev rules.
      cp ${udev}/*/udev/rules.d/*.rules $out/

      # If auto-configuration is disabled, then remove
      # udev's 80-drivers.rules file, which contains rules for
      # automatically calling modprobe.
      ${if config.boot.hardwareScan then
        ''
          substituteInPlace $out/80-drivers.rules \
            --replace /sbin/modprobe ${modprobe}/sbin/modprobe
        ''
        else
        ''
          rm $out/80-drivers.rules
        ''
      }

      # Add the udev rules from other packages.
      for i in ${toString cfg.packages}; do
        for j in $i/*/udev/rules.d/*; do
          ln -s $j $out/$(basename $j)
        done
      done
    ''; # */
  };

  # The udev configuration file.
  conf = writeText "udev.conf" ''
    udev_rules="${udevRules}"
    #udev_log="debug"
  '';

  # Dummy file indicating whether we've run udevtrigger/udevsettle.
  # Since that *recreates* all device nodes with default permissions,
  # it's not nice to do that when a user is logged in (it messes up
  # the permissions set by pam_devperm).
  # !!! Actually, this makes the udev configuration less declarative;
  # changes may not take effect until the user reboots.  We should
  # find a better way to preserve the permissions of logged-in users.
  devicesCreated = "/var/run/devices-created";

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

      sndMode = mkOption {
        default = "0600";
        example = "0666";
        description = ''
          Permissions for sound devices, in case you have multiple
          logged in users or if the devices belong to root for some
          reason.
        '';
      };
        
    };
    
  };
  

  ###### implementation

  config = {

    services.udev.extraRules = nixosRules;
    
    services.udev.packages = [extraUdevRules];

    jobs = singleton
      { name = "udev";

        startOn = "startup";
        stopOn = "shutdown";

        environment = { UDEV_CONFIG_FILE = conf; };

        preStart =
          ''
            echo "" > /proc/sys/kernel/hotplug

            # Get rid of possible old udev processes.
            ${procps}/bin/pkill -u root "^udevd$" || true

            # Do the loading of additional stage 2 kernel modules.
            # Maybe this isn't the best place...
            for i in ${toString config.boot.kernelModules}; do
                echo "Loading kernel module $i..."
                ${modprobe}/sbin/modprobe $i || true
            done

            # Start udev.
            ${udev}/sbin/udevd --daemon

            # Let udev create device nodes for all modules that have already
            # been loaded into the kernel (or for which support is built into
            # the kernel).
            if ! test -e ${devicesCreated}; then
                ${udev}/sbin/udevadm trigger
                ${udev}/sbin/udevadm settle # wait for udev to finish
                touch ${devicesCreated}
            fi

            # Kill udev, let Upstart restart and monitor it.  (This is nasty,
            # but we have to run `udevadm trigger' first.  Maybe we can use
            # Upstart's `binary' keyword, but it isn't implemented yet.)
            if ! ${procps}/bin/pkill -u root "^udevd$"; then
                echo "couldn't stop udevd"
            fi

            while ${procps}/bin/pgrep -u root "^udevd$"; do
                sleep 1
            done

            initctl emit new-devices
          '';

        exec = "${udev}/sbin/udevd";

      };

  };

}
