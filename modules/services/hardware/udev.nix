{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) stdenv writeText procps;

  udev = config.systemd.package;

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
      mkdir -p $out
      shopt -s nullglob

      # Set a reasonable $PATH for programs called by udev rules.
      echo 'ENV{PATH}="${udevPath}/bin:${udevPath}/sbin"' > $out/00-path.rules

      # Add the udev rules from other packages.
      for i in ${toString cfg.packages}; do
        echo "Adding rules for package $i"
        for j in $i/{etc,lib}/udev/rules.d/*; do
          echo "Copying $j to $out/$(basename $j)"
          cat $j > $out/$(basename $j)
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

      echo -n "Checking that all programs called by relative paths in udev rules exist in ${udev}/lib/udev... "
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

      echo -n "Checking that all programs called by absolute paths in udev rules exist... "
      import_progs=$(grep 'IMPORT{program}="\/' $out/* |
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

      ${optionalString (!config.networking.usePredictableInterfaceNames) ''
        ln -s /dev/null $out/80-net-name-slot.rules
      ''}

      # If auto-configuration is disabled, then remove
      # udev's 80-drivers.rules file, which contains rules for
      # automatically calling modprobe.
      ${optionalString (!config.boot.hardwareScan) ''
        ln -s /dev/null $out/80-drivers.rules
      ''}
    ''; # */
  };

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
        type = types.lines;
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

    networking.usePredictableInterfaceNames = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to assign <link
        xlink:href='http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames'>predictable
        names to network interfaces</link>.  If enabled, interfaces
        are assigned names that contain topology information
        (e.g. <literal>wlp3s0</literal>) and thus should be stable
        across reboots.  If disabled, names depend on the order in
        which interfaces are discovered by the kernel, which may
        change randomly across reboots; for instance, you may find
        <literal>eth0</literal> and <literal>eth1</literal> flipping
        unpredictably.
      '';
    };

  };


  ###### implementation

  config = {

    services.udev.extraRules = nixosRules;

    services.udev.packages = [ extraUdevRules ];

    services.udev.path = [ pkgs.coreutils pkgs.gnused pkgs.gnugrep pkgs.utillinux udev ];

    environment.etc =
      [ { source = udevRules;
          target = "udev/rules.d";
        }
      ];

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isEnabled "UNIX")
      (isYes "INOTIFY_USER")
      (isYes "NET")
    ];

    boot.extraKernelParams = [ "firmware_class.path=${config.hardware.firmware}" ];

    boot.extraModprobeConfig = "options firmware_class path=${config.hardware.firmware}";

    system.activationScripts."set-firmware-path" =
      "echo -n ${config.hardware.firmware} > /sys/module/firmware_class/parameters/path";
  };
}
