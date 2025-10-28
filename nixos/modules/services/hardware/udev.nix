{
  config,
  lib,
  pkgs,
  ...
}:
let

  udev = config.systemd.package;

  cfg = config.services.udev;

  initrdUdevRules = pkgs.runCommand "initrd-udev-rules" { } ''
    mkdir -p $out/etc/udev/rules.d
    for f in 60-cdrom_id 60-persistent-storage 75-net-description 80-drivers 80-net-setup-link; do
      ln -s ${config.boot.initrd.systemd.package}/lib/udev/rules.d/$f.rules $out/etc/udev/rules.d
    done
  '';

  extraUdevRules = pkgs.writeTextFile {
    name = "extra-udev-rules";
    text = cfg.extraRules;
    destination = "/etc/udev/rules.d/99-local.rules";
  };

  extraHwdbFile = pkgs.writeTextFile {
    name = "extra-hwdb-file";
    text = cfg.extraHwdb;
    destination = "/etc/udev/hwdb.d/99-local.hwdb";
  };

  nixosRules = ''
    # Needed for gpm.
    SUBSYSTEM=="input", KERNEL=="mice", TAG+="systemd"
  '';

  nixosInitrdRules = ''
    # Mark dm devices as db_persist so that they are kept active after switching root
    SUBSYSTEM=="block", KERNEL=="dm-[0-9]*", ACTION=="add|change", OPTIONS+="db_persist"
  '';

  # Perform substitutions in all udev rules files.
  udevRulesFor =
    {
      name,
      udevPackages,
      udevPath,
      udev,
      systemd,
      binPackages,
      initrdBin ? null,
    }:
    pkgs.runCommand name
      {
        preferLocalBuild = true;
        allowSubstitutes = false;
        packages = lib.unique (map toString udevPackages);

        nativeBuildInputs = [
          # We only include the out output here to avoid needing to include all
          # other outputs in the installer tests as well
          # We only need the udevadm command anyway
          pkgs.buildPackages.systemdMinimal.out
        ];
      }
      ''
        mkdir -p $out
        shopt -s nullglob
        set +o pipefail

        # Set a reasonable $PATH for programs called by udev rules.
        echo 'ENV{PATH}="${udevPath}/bin:${udevPath}/sbin"' > $out/00-path.rules

        # Add the udev rules from other packages.
        for i in $packages; do
          echo "Adding rules for package $i"
          for j in $i/{etc,lib}/udev/rules.d/*; do
            echo "Copying $j to $out/$(basename $j)"
            cat $j > $out/$(basename $j)
          done
        done

        # Fix some paths in the standard udev rules.  Hacky.
        for i in $out/*.rules; do
          substituteInPlace $i \
            --replace-quiet \"/sbin/modprobe \"${pkgs.kmod}/bin/modprobe \
            --replace-quiet \"/sbin/mdadm \"${pkgs.mdadm}/sbin/mdadm \
            --replace-quiet \"/sbin/blkid \"${pkgs.util-linux}/sbin/blkid \
            --replace-quiet \"/bin/mount \"${pkgs.util-linux}/bin/mount \
            --replace-quiet /usr/bin/readlink ${pkgs.coreutils}/bin/readlink \
            --replace-quiet /usr/bin/cat ${pkgs.coreutils}/bin/cat \
            --replace-quiet /usr/bin/basename ${pkgs.coreutils}/bin/basename 2>/dev/null
        ${lib.optionalString (initrdBin != null) ''
          substituteInPlace $i --replace-quiet '/run/current-system/systemd' "${lib.removeSuffix "/bin" initrdBin}"
        ''}
        done

        echo -n "Checking that all programs called by relative paths in udev rules exist in ${udev}/lib/udev... "
        import_progs=$(grep 'IMPORT{program}="[^/$]' $out/* |
          sed -e 's/.*IMPORT{program}="\([^ "]*\)[ "].*/\1/' | uniq)
        run_progs=$(grep -v '^[[:space:]]*#' $out/* | grep 'RUN+="[^/$]' |
          sed -e 's/.*RUN+="\([^ "]*\)[ "].*/\1/' | uniq)
        for i in $import_progs $run_progs; do
          if [[ ! -x ${udev}/lib/udev/$i && ! $i =~ socket:.* ]]; then
            echo "FAIL"
            echo "$i is called in udev rules but not installed by udev"
            exit 1
          fi
        done
        echo "OK"

        echo -n "Checking that all programs called by absolute paths in udev rules exist... "
        import_progs=$(grep 'IMPORT{program}="/' $out/* |
          sed -e 's/.*IMPORT{program}="\([^ "]*\)[ "].*/\1/' | uniq)
        run_progs=$(grep -v '^[[:space:]]*#' $out/* | grep 'RUN+="/' |
          sed -e 's/.*RUN+="\([^ "]*\)[ "].*/\1/' | uniq)
        for i in $import_progs $run_progs; do
          # if the path refers to /run/current-system/systemd, replace with config.systemd.package
          if [[ $i == /run/current-system/systemd* ]]; then
            i="${systemd}/''${i#/run/current-system/systemd/}"
          fi

          if [[ ! -x $i ]]; then
            echo "FAIL"
            echo "$i is called in udev rules but is not executable or does not exist"
            exit 1
          fi
        done
        echo "OK"

        filesToFixup="$(for i in "$out"/*; do
          # list all files referring to (/usr)/bin paths, but allow references to /bin/sh.
          grep -P -l '\B(?!\/bin\/sh\b)(\/usr)?\/bin(?:\/.*)?' "$i" || :
        done)"

        if [ -n "$filesToFixup" ]; then
          echo "Consider fixing the following udev rules:"
          echo "$filesToFixup" | while read localFile; do
            remoteFile="origin unknown"
            for i in ${toString binPackages}; do
              for j in "$i"/*/udev/rules.d/*; do
                [ -e "$out/$(basename "$j")" ] || continue
                [ "$(basename "$j")" = "$(basename "$localFile")" ] || continue
                remoteFile="originally from $j"
                break 2
              done
            done
            refs="$(
              grep -o '\B\(/usr\)\?/s\?bin/[^ "]\+' "$localFile" \
                | sed -e ':r;N;''${s/\n/ and /;br};s/\n/, /g;br'
            )"
            echo "$localFile ($remoteFile) contains references to $refs."
          done
          exit 1
        fi

        # Verify all the udev rules
        echo "Verifying udev rules using udevadm verify..."
        udevadm verify --resolve-names=late --no-style $out
        echo "OK"

        # If auto-configuration is disabled, then remove
        # udev's 80-drivers.rules file, which contains rules for
        # automatically calling modprobe.
        ${lib.optionalString (!config.boot.hardwareScan) ''
          ln -s /dev/null $out/80-drivers.rules
        ''}
      '';

  hwdbBin =
    pkgs.runCommand "hwdb.bin"
      {
        preferLocalBuild = true;
        allowSubstitutes = false;
        packages = lib.unique (map toString ([ udev ] ++ cfg.packages));
      }
      ''
        mkdir -p etc/udev/hwdb.d
        for i in $packages; do
          echo "Adding hwdb files for package $i"
          for j in $i/{etc,lib}/udev/hwdb.d/*; do
            # This must be a copy, not a symlink, because --root below will chase links within the root argument.
            cp $j etc/udev/hwdb.d/$(basename $j)
          done
        done

        echo "Generating hwdb database..."
        # hwdb --update doesn't return error code even on errors!
        res="$(${pkgs.buildPackages.systemd}/bin/systemd-hwdb --root=$(pwd) update 2>&1)"
        echo "$res"
        [ -z "$(echo "$res" | egrep '^Error')" ]
        mv etc/udev/hwdb.bin $out
      '';

  compressFirmware =
    firmware:
    if
      config.hardware.firmwareCompression == "none" || (firmware.compressFirmware or true) == false
    then
      firmware
    else if config.hardware.firmwareCompression == "zstd" then
      pkgs.compressFirmwareZstd firmware
    else
      pkgs.compressFirmwareXz firmware;

  # Udev has a 512-character limit for ENV{PATH}, so create a symlink
  # tree to work around this.
  udevPath = pkgs.buildEnv {
    name = "udev-path";
    paths = cfg.path;
    pathsToLink = [
      "/bin"
      "/sbin"
    ];
    ignoreCollisions = true;
  };

in

{

  ###### interface

  options = {
    boot.hardwareScan = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to try to load kernel modules for all detected hardware.
        Usually this does a good job of providing you with the modules
        you need, but sometimes it can crash the system or cause other
        nasty effects.
      '';
    };

    services.udev = {
      enable = lib.mkEnableOption "udev, a device manager for the Linux kernel" // {
        default = true;
      };

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          List of packages containing {command}`udev` rules.
          All files found in
          {file}`«pkg»/etc/udev/rules.d` and
          {file}`«pkg»/lib/udev/rules.d`
          will be included.
        '';
        apply = map lib.getBin;
      };

      path = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          Packages added to the {env}`PATH` environment variable when
          executing programs from Udev rules.

          coreutils, gnu{sed,grep}, util-linux and config.systemd.package are
          automatically included.
        '';
      };

      extraRules = lib.mkOption {
        default = "";
        example = ''
          ENV{ID_VENDOR_ID}=="046d", ENV{ID_MODEL_ID}=="0825", ENV{PULSE_IGNORE}="1"
        '';
        type = lib.types.lines;
        description = ''
          Additional {command}`udev` rules. They'll be written
          into file {file}`99-local.rules`. Thus they are
          read and applied after all other rules.
        '';
      };

      extraHwdb = lib.mkOption {
        default = "";
        example = ''
          evdev:input:b0003v05AFp8277*
            KEYBOARD_KEY_70039=leftalt
            KEYBOARD_KEY_700e2=leftctrl
        '';
        type = lib.types.lines;
        description = ''
          Additional {command}`hwdb` files. They'll be written
          into file {file}`99-local.hwdb`. Thus they are
          read after all other files.
        '';
      };

    };

    hardware.firmware = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        List of packages containing firmware files.  Such files
        will be loaded automatically if the kernel asks for them
        (i.e., when it has detected specific hardware that requires
        firmware to function).  If multiple packages contain firmware
        files with the same name, the first package in the list takes
        precedence.  Note that you must rebuild your system if you add
        files to any of these directories.
      '';
      apply =
        list:
        pkgs.buildEnv {
          name = "firmware";
          paths = map compressFirmware list;
          pathsToLink = [ "/lib/firmware" ];
          ignoreCollisions = true;
        };
    };

    hardware.firmwareCompression = lib.mkOption {
      type = lib.types.enum [
        "xz"
        "zstd"
        "none"
      ];
      default =
        if config.boot.kernelPackages.kernelAtLeast "5.19" then
          "zstd"
        else if config.boot.kernelPackages.kernelAtLeast "5.3" then
          "xz"
        else
          "none";
      defaultText = "auto";
      description = ''
        Whether to compress firmware files.
        Defaults depend on the kernel version.
        For kernels older than 5.3, firmware files are not compressed.
        For kernels 5.3 and newer, firmware files are compressed with xz.
        For kernels 5.19 and newer, firmware files are compressed with zstd.
      '';
    };

    networking.usePredictableInterfaceNames = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = ''
        Whether to assign [predictable names to network interfaces](https://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/).
        If enabled, interfaces
        are assigned names that contain topology information
        (e.g. `wlp3s0`) and thus should be stable
        across reboots.  If disabled, names depend on the order in
        which interfaces are discovered by the kernel, which may
        change randomly across reboots; for instance, you may find
        `eth0` and `eth1` flipping
        unpredictably.
      '';
    };

    boot.initrd.services.udev = {

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          *This will only be used when systemd is used in stage 1.*

          List of packages containing {command}`udev` rules that will be copied to stage 1.
          All files found in
          {file}`«pkg»/etc/udev/rules.d` and
          {file}`«pkg»/lib/udev/rules.d`
          will be included.
        '';
      };

      binPackages = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          *This will only be used when systemd is used in stage 1.*

          Packages to search for binaries that are referenced by the udev rules in stage 1.
          This list always contains /bin of the initrd.
        '';
        apply = map lib.getBin;
      };

      rules = lib.mkOption {
        default = "";
        example = ''
          SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="00:1D:60:B9:6D:4F", KERNEL=="eth*", NAME="my_fast_network_card"
        '';
        type = lib.types.lines;
        description = ''
          {command}`udev` rules to include in the initrd
          *only*. They'll be written into file
          {file}`99-local.rules`. Thus they are read and applied
          after the essential initrd rules.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion =
          config.hardware.firmwareCompression == "zstd" -> config.boot.kernelPackages.kernelAtLeast "5.19";
        message = ''
          The firmware compression method is set to zstd, but the kernel version is too old.
          The kernel version must be at least 5.3 to use zstd compression.
        '';
      }
      {
        assertion =
          config.hardware.firmwareCompression == "xz" -> config.boot.kernelPackages.kernelAtLeast "5.3";
        message = ''
          The firmware compression method is set to xz, but the kernel version is too old.
          The kernel version must be at least 5.3 to use xz compression.
        '';
      }
    ];

    services.udev.extraRules = nixosRules;

    services.udev.packages = [
      extraUdevRules
      extraHwdbFile
    ];

    services.udev.path = [
      pkgs.coreutils
      pkgs.gnused
      pkgs.gnugrep
      pkgs.util-linux
      udev
    ];

    boot.kernelParams = lib.mkIf (!config.networking.usePredictableInterfaceNames) [ "net.ifnames=0" ];

    boot.initrd.extraUdevRulesCommands =
      lib.mkIf (!config.boot.initrd.systemd.enable && config.boot.initrd.services.udev.rules != "")
        ''
          cat <<'EOF' > $out/99-local.rules
          ${config.boot.initrd.services.udev.rules}
          EOF
        '';

    boot.initrd.services.udev.rules = nixosInitrdRules;

    boot.initrd.systemd.additionalUpstreamUnits = [
      "initrd-udevadm-cleanup-db.service"
      "systemd-udevd-control.socket"
      "systemd-udevd-kernel.socket"
      "systemd-udevd.service"
      "systemd-udev-settle.service"
      "systemd-udev-trigger.service"
    ];
    boot.initrd.systemd.storePaths = [
      "${config.boot.initrd.systemd.package}/lib/systemd/systemd-udevd"
      "${config.boot.initrd.systemd.package}/lib/udev/ata_id"
      "${config.boot.initrd.systemd.package}/lib/udev/cdrom_id"
      "${config.boot.initrd.systemd.package}/lib/udev/dmi_memory_id"
      "${config.boot.initrd.systemd.package}/lib/udev/scsi_id"
      "${config.boot.initrd.systemd.package}/lib/udev/rules.d"
    ]
    ++ map (x: "${x}/bin") config.boot.initrd.services.udev.binPackages;

    # Generate the udev rules for the initrd
    boot.initrd.systemd.contents = {
      "/etc/udev/rules.d".source = udevRulesFor {
        name = "initrd-udev-rules";
        initrdBin = config.boot.initrd.systemd.contents."/bin".source;
        udevPackages = config.boot.initrd.services.udev.packages;
        udevPath = config.boot.initrd.systemd.contents."/bin".source;
        udev = config.boot.initrd.systemd.package;
        systemd = config.boot.initrd.systemd.package;
        binPackages = config.boot.initrd.services.udev.binPackages ++ [
          config.boot.initrd.systemd.contents."/bin".source
        ];
      };
    };
    # Insert initrd rules
    boot.initrd.services.udev.packages = [
      initrdUdevRules
      (lib.mkIf (config.boot.initrd.services.udev.rules != "") (
        pkgs.writeTextFile {
          name = "initrd-udev-rules";
          destination = "/etc/udev/rules.d/99-local.rules";
          text = config.boot.initrd.services.udev.rules;
        }
      ))
    ];

    environment.etc = {
      "udev/rules.d".source = udevRulesFor {
        name = "udev-rules";
        udevPackages = cfg.packages;
        systemd = config.systemd.package;
        binPackages = cfg.packages;
        inherit udevPath udev;
      };
      "udev/hwdb.bin".source = hwdbBin;
    }
    // lib.optionalAttrs config.boot.modprobeConfig.enable {
      # We don't place this into `extraModprobeConfig` so that stage-1 ramdisk doesn't bloat.
      "modprobe.d/firmware.conf".text =
        "options firmware_class path=${config.hardware.firmware}/lib/firmware";
    };

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isEnabled "UNIX")
      (isYes "INOTIFY_USER")
      (isYes "NET")
    ];

    system.activationScripts.udevd = lib.mkIf config.boot.kernel.enable ''
      # The deprecated hotplug uevent helper is not used anymore
      if [ -e /proc/sys/kernel/hotplug ]; then
        echo "" > /proc/sys/kernel/hotplug
      fi

      # Allow the kernel to find our firmware.
      if [ -e /sys/module/firmware_class/parameters/path ]; then
        echo -n "${config.hardware.firmware}/lib/firmware" > /sys/module/firmware_class/parameters/path
      fi
    '';

    systemd.services.systemd-udevd = {
      restartTriggers = [ config.environment.etc."udev/rules.d".source ];
      notSocketActivated = true;
      stopIfChanged = false;
    };
  };

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "udev" "initrdRules" ]
      [ "boot" "initrd" "services" "udev" "rules" ]
    )
  ];
}
