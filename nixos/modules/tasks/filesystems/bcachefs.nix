{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfgScrub = config.services.bcachefs.autoScrub;

  bootFs = lib.filterAttrs (
    n: fs: (fs.fsType == "bcachefs") && (utils.fsNeededForBoot fs)
  ) config.fileSystems;

  commonFunctions = ''
    prompt() {
        local name="$1"
        printf "enter passphrase for $name: "
    }

    tryUnlock() {
        local name="$1"
        local path="$2"
        local success=false
        local target
        local uuid=$(echo -n $path | sed -e 's,UUID=\(.*\),\1,g')

        printf "waiting for device to appear $path"
        for try in $(seq 10); do
          if [ -e $path ]; then
              target=$(readlink -f $path)
              success=true
              break
          else
              target=$(blkid --uuid $uuid)
              if [ $? == 0 ]; then
                 success=true
                 break
              fi
          fi
          echo -n "."
          sleep 1
        done
        printf "\n"
        if [ $success == true ]; then
            path=$target
        fi

        if bcachefs unlock -c $path > /dev/null 2> /dev/null; then    # test for encryption
            prompt $name
            until bcachefs unlock $path 2> /dev/null; do              # repeat until successfully unlocked
                printf "unlocking failed!\n"
                prompt $name
            done
            printf "unlocking successful.\n"
        else
            echo "Cannot unlock device $uuid with path $path" >&2
        fi
    }
  '';

  # we need only unlock one device manually, and cannot pass multiple at once
  # remove this adaptation when bcachefs implements mounting by filesystem uuid
  # also, implement automatic waiting for the constituent devices when that happens
  # bcachefs does not support mounting devices with colons in the path, ergo we don't (see #49671)
  firstDevice = fs: lib.head (lib.splitString ":" fs.device);

  useClevis =
    fs:
    config.boot.initrd.clevis.enable
    && (lib.hasAttr (firstDevice fs) config.boot.initrd.clevis.devices);

  openCommand =
    name: fs:
    if useClevis fs then
      ''
        if clevis decrypt < /etc/clevis/${firstDevice fs}.jwe | bcachefs unlock ${firstDevice fs}
        then
          printf "unlocked ${name} using clevis\n"
        else
          printf "falling back to interactive unlocking...\n"
          tryUnlock ${name} ${firstDevice fs}
        fi
      ''
    else
      ''
        tryUnlock ${name} ${firstDevice fs}
      '';

  mkUnits =
    prefix: name: fs:
    let
      mountUnit = "${utils.escapeSystemdPath (prefix + (lib.removeSuffix "/" fs.mountPoint))}.mount";
      device = firstDevice fs;
      deviceUnit = "${utils.escapeSystemdPath device}.device";
    in
    {
      name = "unlock-bcachefs-${utils.escapeSystemdPath fs.mountPoint}";
      value = {
        description = "Unlock bcachefs for ${fs.mountPoint}";
        requiredBy = [ mountUnit ];
        after = [ deviceUnit ];
        before = [
          mountUnit
          "shutdown.target"
        ];
        bindsTo = [ deviceUnit ];
        conflicts = [ "shutdown.target" ];
        unitConfig.DefaultDependencies = false;
        serviceConfig = {
          Type = "oneshot";
          ExecCondition = "${pkgs.bcachefs-tools}/bin/bcachefs unlock -c \"${device}\"";
          Restart = "on-failure";
          RestartMode = "direct";
          # Ideally, this service would lock the key on stop.
          # As is, RemainAfterExit doesn't accomplish anything.
          RemainAfterExit = true;
        };
        script =
          let
            unlock = ''${pkgs.bcachefs-tools}/bin/bcachefs unlock "${device}"'';
            unlockInteractively = ''${config.boot.initrd.systemd.package}/bin/systemd-ask-password --timeout=0 "enter passphrase for ${name}" | exec ${unlock}'';
          in
          if useClevis fs then
            ''
              if ${config.boot.initrd.clevis.package}/bin/clevis decrypt < "/etc/clevis/${device}.jwe" | ${unlock}
              then
                printf "unlocked ${name} using clevis\n"
              else
                printf "falling back to interactive unlocking...\n"
                ${unlockInteractively}
              fi
            ''
          else
            ''
              ${unlockInteractively}
            '';
      };
    };

  assertions = [
    {
      assertion =
        let
          kernel = config.boot.kernelPackages.kernel;
        in
        (
          kernel.kernelAtLeast "6.7"
          || (lib.elem (kernel.structuredExtraConfig.BCACHEFS_FS or null) [
            lib.kernel.module
            lib.kernel.yes
            (lib.kernel.option lib.kernel.yes)
          ])
        );

      message = "Linux 6.7-rc1 at minimum or a custom linux kernel with bcachefs support is required";
    }
  ];
in

{
  options.services.bcachefs.autoScrub = {
    enable = lib.mkEnableOption "regular bcachefs scrub";

    fileSystems = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      example = [ "/" ];
      description = ''
        List of paths to bcachefs filesystems to regularly call {command}`bcachefs scrub` on.
        Defaults to all mount points with bcachefs filesystems.
      '';
    };

    interval = lib.mkOption {
      default = "monthly";
      type = lib.types.str;
      example = "weekly";
      description = ''
        Systemd calendar expression for when to scrub bcachefs filesystems.
        The recommended period is a month but could be less.
        See
        {manpage}`systemd.time(7)`
        for more information on the syntax.
      '';
    };
  };

  config = lib.mkIf (config.boot.supportedFilesystems.bcachefs or false) (
    lib.mkMerge [
      {
        inherit assertions;
        # needed for systemd-remount-fs
        system.fsPackages = [ pkgs.bcachefs-tools ];
        # FIXME: Remove this line when the LTS (default) kernel is at least version 6.7
        boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
        services.udev.packages = [ pkgs.bcachefs-tools ];

        systemd = {
          packages = [ pkgs.bcachefs-tools ];
          services = lib.mapAttrs' (mkUnits "") (
            lib.filterAttrs (n: fs: (fs.fsType == "bcachefs") && (!utils.fsNeededForBoot fs)) config.fileSystems
          );
        };
      }

      (lib.mkIf ((config.boot.initrd.supportedFilesystems.bcachefs or false) || (bootFs != { })) {
        inherit assertions;
        # chacha20 and poly1305 are required only for decryption attempts
        boot.initrd.availableKernelModules = [
          "bcachefs"
          "sha256"
          "chacha20"
          "poly1305"
        ];
        boot.initrd.systemd.extraBin = {
          # do we need this? boot/systemd.nix:566 & boot/systemd/initrd.nix:357
          "bcachefs" = "${pkgs.bcachefs-tools}/bin/bcachefs";
          "mount.bcachefs" = "${pkgs.bcachefs-tools}/bin/mount.bcachefs";
        };
        boot.initrd.extraUtilsCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
          copy_bin_and_libs ${pkgs.bcachefs-tools}/bin/bcachefs
          copy_bin_and_libs ${pkgs.bcachefs-tools}/bin/mount.bcachefs
        '';
        boot.initrd.extraUtilsCommandsTest = lib.mkIf (!config.boot.initrd.systemd.enable) ''
          $out/bin/bcachefs version
        '';

        boot.initrd.postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) (
          commonFunctions + lib.concatStrings (lib.mapAttrsToList openCommand bootFs)
        );

        boot.initrd.systemd.services = lib.mapAttrs' (mkUnits "/sysroot") bootFs;
      })

      (lib.mkIf (cfgScrub.enable) {
        assertions = [
          {
            assertion = lib.versionAtLeast config.boot.kernelPackages.kernel.version "6.14";
            message = "Bcachefs scrubbing is supported from kernel version 6.14 or later.";
          }
          {
            assertion = cfgScrub.enable -> (cfgScrub.fileSystems != [ ]);
            message = ''
              If 'services.bcachefs.autoScrub' is enabled, you need to have at least one
              bcachefs file system mounted via 'fileSystems' or specify a list manually
              in 'services.bcachefs.autoScrub.fileSystems'.
            '';
          }
        ];

        # This will remove duplicated units from either having a filesystem mounted multiple
        # time, or additionally mounted subvolumes, as well as having a filesystem span
        # multiple devices (provided the same device is used to mount said filesystem).
        services.bcachefs.autoScrub.fileSystems =
          let
            isDeviceInList = list: device: builtins.filter (e: e.device == device) list != [ ];

            uniqueDeviceList = lib.foldl' (
              acc: e: if isDeviceInList acc e.device then acc else acc ++ [ e ]
            ) [ ];
          in
          lib.mkDefault (
            map (e: e.mountPoint) (
              uniqueDeviceList (
                lib.mapAttrsToList (name: fs: {
                  mountPoint = fs.mountPoint;
                  device = fs.device;
                }) (lib.filterAttrs (name: fs: fs.fsType == "bcachefs") config.fileSystems)
              )
            )
          );

        systemd.timers =
          let
            scrubTimer =
              fs:
              let
                fs' = utils.escapeSystemdPath fs;
              in
              lib.nameValuePair "bcachefs-scrub-${fs'}" {
                description = "regular bcachefs scrub timer on ${fs}";

                wantedBy = [ "timers.target" ];
                timerConfig = {
                  OnCalendar = cfgScrub.interval;
                  AccuracySec = "1d";
                  Persistent = true;
                };
              };
          in
          lib.listToAttrs (map scrubTimer cfgScrub.fileSystems);

        systemd.services =
          let
            scrubService =
              fs:
              let
                fs' = utils.escapeSystemdPath fs;
              in
              lib.nameValuePair "bcachefs-scrub-${fs'}" {
                description = "bcachefs scrub on ${fs}";
                # scrub prevents suspend2ram or proper shutdown
                conflicts = [
                  "shutdown.target"
                  "sleep.target"
                ];
                before = [
                  "shutdown.target"
                  "sleep.target"
                ];

                script = "${lib.getExe pkgs.bcachefs-tools} data scrub ${fs}";

                serviceConfig = {
                  Type = "oneshot";
                  Nice = 19;
                  IOSchedulingClass = "idle";
                };
              };
          in
          lib.listToAttrs (map scrubService cfgScrub.fileSystems);
      })
    ]
  );

  meta = {
    inherit (pkgs.bcachefs-tools.meta) maintainers;
  };
}
