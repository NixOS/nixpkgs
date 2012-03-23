{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) stdenv writeText udev procps;

  cfg = config.services.udev;

  extraUdevRules = pkgs.writeTextFile {
    name = "extra-udev-rules";
    text = cfg.extraRules;
    destination = "/etc/udev/rules.d/10-local.rules";
  };

  nixosRules = ''
    # Miscellaneous devices.
    KERNEL=="kvm",                  MODE="0666"
    KERNEL=="kqemu",                MODE="0666"
  '';

  # Perform substitutions in all udev rules files.
  udevRules = stdenv.mkDerivation {
    name = "udev-rules";
    buildCommand = ''
      ensureDir $out
      shopt -s nullglob

      # Set a reasonable $PATH for programs called by udev rules.
      echo 'ENV{PATH}="${udevPath}/bin:${udevPath}/sbin"' > $out/00-path.rules

      # Set the firmware search path so that the firmware.sh helper
      # called by 50-firmware.rules works properly.
      echo 'ENV{FIRMWARE_DIRS}="/root/test-firmware ${toString config.hardware.firmware}"' >> $out/00-path.rules

      # Add the udev rules from other packages.
      for i in ${toString cfg.packages}; do
        echo "Adding rules for package $i"
        for j in $i/*/udev/rules.d/*; do
          echo "Copying $j to $out/$(basename $j)"
          echo "# Copied from $j" > $out/$(basename $j)
          cat $j >> $out/$(basename $j)
        done
      done

      # Fix some paths in the standard udev rules.  Hacky.
      for i in $out/*.rules; do
        substituteInPlace $i \
          --replace \"/sbin/modprobe \"${config.system.sbin.modprobe}/sbin/modprobe \
          --replace \"/sbin/mdadm \"${pkgs.mdadm}/sbin/mdadm \
          --replace \"/sbin/blkid \"${pkgs.utillinux}/sbin/blkid \
          --replace \"/bin/mount \"${pkgs.utillinux}/bin/mount
      done

      # If auto-configuration is disabled, then remove
      # udev's 80-drivers.rules file, which contains rules for
      # automatically calling modprobe.
      ${if !config.boot.hardwareScan then "rm $out/80-drivers.rules" else ""}

      echo -n "Checking that all programs called by relative paths in udev rules exist in ${udev}/lib/udev ... "
      import_progs=$(grep 'IMPORT{program}="[^/$]' $out/* |
        sed -e 's/.*IMPORT{program}="\([^ "]*\)[ "].*/\1/' | uniq)
      run_progs=$(grep -v '^[[:space:]]*#' $out/* | grep 'RUN+="[^/$]' |
        sed -e 's/.*RUN+="\([^ "]*\)[ "].*/\1/' | uniq)
      for i in $import_progs $run_progs; do
        if [[ ! -x ${pkgs.udev}/lib/udev/$i && ! $i =~ socket:.* ]]; then
          echo "FAIL"
          echo "$i is called in udev rules but not installed by udev"
          exit 1
        fi
      done
      echo "OK"

      echo -n "Checking that all programs call by absolute paths in udev rules exist ... "
      import_progs=$(grep 'IMPORT{program}="/' $out/* |
        sed -e 's/.*IMPORT{program}="\([^ "]*\)[ "].*/\1/' | uniq)
      run_progs=$(grep -v '^[[:space:]]*#' $out/* | grep 'RUN+="/' |
        sed -e 's/.*RUN+="\([^ "]*\)[ "].*/\1/' | uniq)
      for i in $import_progs $run_progs; do
        if [[ ! -x $i ]]; then
          echo "FAIL"
          echo "$i is called in udev rules but not installed by udev"
          exit 1
        fi
      done
      echo "OK"

      echo "Consider fixing the following udev rules:"
      for i in ${toString cfg.packages}; do
        grep -l '\(RUN+\|IMPORT{program}\)="\(/usr\)\?/s\?bin' $i/*/udev/rules.d/* || true
      done

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

  # Udev has a 512-character limit for ENV{PATH}, so create a symlink
  # tree to work around this.
  udevPath = pkgs.buildEnv {
    name = "udev-path";
    paths = cfg.path;
    pathsToLink = [ "/bin" "/sbin" ];
    ignoreCollisions = true;
  };

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
        nasty effects.
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

      path = mkOption {
        default = [];
        merge = mergeListOption;
        description = ''
          Packages added to the <envar>PATH</envar> environment variable when
          executing programs from Udev rules.
        '';
      };

      extraRules = mkOption {
        default = "";
        example = ''
          KERNEL=="eth*", ATTR{address}=="00:1D:60:B9:6D:4F", NAME="my_fast_network_card"
        '';
        type = with pkgs.lib.types; string;
        description = ''
          Additional <command>udev</command> rules. They'll be written
          into file <filename>10-local.rules</filename>. Thus they are
          read before all other rules.
        '';
      };

    };

    hardware.firmware = mkOption {
      default = [];
      example = [ "/root/my-firmware" ];
      merge = mergeListOption;
      description = ''
        List of directories containing firmware files.  Such files
        will be loaded automatically if the kernel asks for them
        (i.e., when it has detected specific hardware that requires
        firmware to function).  If more than one path contains a
        firmware file with the same name, the first path in the list
        takes precedence.  Note that you must rebuild your system if
        you add files to any of these directories.  For quick testing,
        put firmware files in /root/test-firmware and add that
        directory to the list.
        Note that you can also add firmware packages to this
        list as these are directories in the nix store.
      '';
      apply = list: pkgs.buildEnv {
        name = "firmware";
        paths = list;
        pathsToLink = [ "/" ];
        ignoreCollisions = true;
      };
    };

  };


  ###### implementation

  config = {

    services.udev.extraRules = nixosRules;

    services.udev.packages = [ pkgs.udev extraUdevRules ];

    services.udev.path = [ pkgs.coreutils pkgs.gnused pkgs.gnugrep pkgs.utillinux pkgs.udev ];

    jobs.udev =
      { startOn = "startup";

        environment = { UDEV_CONFIG_FILE = conf; };

        path = [ udev ];

        preStart =
          ''
            echo "" > /proc/sys/kernel/hotplug || true

            mkdir -p /var/lib/udev/rules.d
            touch /var/lib/udev/rules.d/70-persistent-cd.rules /var/lib/udev/rules.d/70-persistent-net.rules

            mkdir -p /dev/.udev # !!! bug in udev?
          '';

        daemonType = "fork";

        exec = "udevd --daemon";

        postStart =
          ''
            # Do the loading of additional stage 2 kernel modules.
            # This needs to be done while udevd is running, because
            # the modules may call upon udev's firmware loading rule.
            for i in ${toString config.boot.kernelModules}; do
                echo "loading kernel module ‘$i’..."
                ${config.system.sbin.modprobe}/sbin/modprobe $i || true
            done
          '';
      };

    jobs.udevtrigger =
      { startOn = "started udev";

        task = true;

        path = [ udev ];

        script =
          ''
            # Let udev create device nodes for all modules that have already
            # been loaded into the kernel (or for which support is built into
            # the kernel).
            udevadm trigger --action=add
            udevadm settle || true # wait for udev to finish

            initctl emit -n new-devices
          '';
      };

  };

}
