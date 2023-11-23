{ config, lib, pkgs, utils, ... }:

let

  bootFs = lib.filterAttrs (n: fs: (fs.fsType == "bcachefs") && (utils.fsNeededForBoot fs)) config.fileSystems;

  # adapted from LUKS
  commonFunctions = ''
    dev_exist() {
        local target="$1"
        if [ -e $target ]; then
            return 0
        else
            local uuid=$(echo -n $target | sed -e 's,UUID=\(.*\),\1,g')
            blkid --uuid $uuid >/dev/null
            return $?
        fi
    }

    wait_target() {
        local name="$1"
        local target="$2"
        local secs="''${3:-10}"
        local desc="''${4:-$name $target to appear}"

        if ! dev_exist $target; then
            echo -n "Waiting $secs seconds for $desc..."
            local success=false;
            for try in $(seq $secs); do
                echo -n "."
                sleep 1
                if dev_exist $target; then
                    success=true
                    break
                fi
            done
            if [ $success == true ]; then
                echo " - success";
                return 0
            else
                echo " - failure";
                return 1
            fi
        fi
        return 0
    }

    bcachefs_do_open_passphrase() {
        local name="$1"
        local target="$2"
        local passphrase

        while true; do
            echo -n "Passphrase for $target: "
            passphrase=
            while true; do
                if [ -e /bcachefs-ramfs/passphrase ]; then
                    echo "reused"
                    passphrase=$(cat /bcachefs-ramfs/passphrase)
                    break
                else
                    # ask bcachefs-askpass
                    echo -n "$target" > /bcachefs-ramfs/device

                    # and try reading it from /dev/console with a timeout
                    IFS= read -t 1 -r passphrase
                    if [ -n "$passphrase" ]; then
                       ${if true then ''
                         # remember it for the next device
                         echo -n "$passphrase" > /bcachefs-ramfs/passphrase
                       '' else ''
                         # Don't save it to ramfs. We are very paranoid
                       ''}
                       echo
                       break
                    fi
                fi
            done
            echo -n "Verifying passphrase for $target..."
            echo -n "$passphrase" | bcachefs unlock "$target" 2> /dev/null
            if [ $? == 0 ]; then
                echo " - success"
                ${if true then ''
                  # we don't rm here because we might reuse it for the next device
                '' else ''
                  rm -f /bcachefs-ramfs/passphrase
                ''}
                break
            else
                echo " - failure"
                # ask for a different one
                rm -f /bcachefs-ramfs/passphrase
            fi
        done
    }

    # bcachefs
    bcachefs_open_normally() {
        local name="$1"
        local target="$2"

        wait_target "$name" "$path" || die "$path is unavailable"
        if bcachefs unlock -c "$path" > /dev/null 2> /dev/null; then    # test for encryption
            bcachefs_do_open_passphrase "$name" "$path"
            printf "unlocking successful.\n"
        else
            echo "Cannot unlock device $uuid with path $path" >&2
        fi
    }
  '';

  preCommands = ''
    # A place to store crypto things

    # A ramfs is used here to ensure that the file used to update
    # the key slot with cryptsetup will never get swapped out.
    # Warning: Do NOT replace with tmpfs!
    mkdir -p /bcachefs-ramfs
    mount -t ramfs none /bcachefs-ramfs

    # Disable all input echo for the whole stage. We could use read -s
    # instead but that would occasionally leak characters between read
    # invocations.
    stty -echo
  '';

  postCommands = ''
    stty echo
    umount /bcachefs-ramfs 2>/dev/null
  '';

  askPass = pkgs.writeScriptBin "bcachefs-askpass" ''
    #!/bin/sh

    ${commonFunctions}

    while true; do
        wait_target "bcachefs" /bcachefs-ramfs/device 10 "Bcachefs to request a passphrase" || die "Passphrase is not requested now"
        device="$(cat /bcachefs-ramfs/device)"

        echo -n "Passphrase for $device: "
        IFS= read -rs passphrase
        echo

        rm /bcachefs-ramfs/device
        echo -n "$passphrase" > /bcachefs-ramfs/passphrase
    done
  '';

  # we need only unlock one device manually, and cannot pass multiple at once
  # remove this adaptation when bcachefs implements mounting by filesystem uuid
  # also, implement automatic waiting for the constituent devices when that happens
  # bcachefs does not support mounting devices with colons in the path, ergo we don't (see #49671)
  firstDevice = fs: lib.head (lib.splitString ":" fs.device);

  openCommand = name: fs: ''
    bcachefs_open_normally ${name} ${firstDevice fs}
  '';

  mkUnits = prefix: name: fs: let
    mountUnit = "${utils.escapeSystemdPath (prefix + (lib.removeSuffix "/" fs.mountPoint))}.mount";
    device = firstDevice fs;
    deviceUnit = "${utils.escapeSystemdPath device}.device";
  in {
    name = "unlock-bcachefs-${utils.escapeSystemdPath fs.mountPoint}";
    value = {
      description = "Unlock bcachefs for ${fs.mountPoint}";
      requiredBy = [ mountUnit ];
      before = [ mountUnit ];
      bindsTo = [ deviceUnit ];
      after = [ deviceUnit ];
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
      script = ''
        ${config.boot.initrd.systemd.package}/bin/systemd-ask-password --timeout=0 "enter passphrase for ${name}" | exec ${pkgs.bcachefs-tools}/bin/bcachefs unlock "${device}"
      '';
    };
  };

  assertions = [
    {
      assertion = let
        kernel = config.boot.kernelPackages.kernel;
      in (
        kernel.kernelAtLeast "6.7" || (
          lib.elem (kernel.structuredExtraConfig.BCACHEFS_FS or null) [
            lib.kernel.module
            lib.kernel.yes
            lib.kernel.option.yes
          ]
        )
      );

      message = "Linux 6.7-rc1 at minimum or a custom linux kernel with bcachefs support is required";
    }
  ];
in

{
  config = lib.mkIf (lib.elem "bcachefs" config.boot.supportedFilesystems) (lib.mkMerge [
    {
      inherit assertions;
      # needed for systemd-remount-fs
      system.fsPackages = [ pkgs.bcachefs-tools ];

      # FIXME: Replace this with `linuxPackages_testing` after NixOS 23.11 is released
      # FIXME: Replace this with `linuxPackages_latest` when 6.7 is released, remove this line when the LTS version is at least 6.7
      boot.kernelPackages = lib.mkDefault (
        # FIXME: Remove warning after NixOS 23.11 is released
        lib.warn "Please upgrade to Linux 6.7-rc1 or later: 'linuxPackages_testing_bcachefs' is deprecated. Use 'boot.kernelPackages = pkgs.linuxPackages_testing;' to silence this warning"
        pkgs.linuxPackages_testing_bcachefs
      );

      systemd.services = lib.mapAttrs' (mkUnits "") (lib.filterAttrs (n: fs: (fs.fsType == "bcachefs") && (!utils.fsNeededForBoot fs)) config.fileSystems);
    }

    (lib.mkIf ((lib.elem "bcachefs" config.boot.initrd.supportedFilesystems) || (bootFs != {})) {
      inherit assertions;
      # chacha20 and poly1305 are required only for decryption attempts
      boot.initrd.availableKernelModules = [ "bcachefs" "sha256" "chacha20" "poly1305" ];
      boot.initrd.systemd.extraBin = {
        # do we need this? boot/systemd.nix:566 & boot/systemd/initrd.nix:357
        "bcachefs" = "${pkgs.bcachefs-tools}/bin/bcachefs";
        "mount.bcachefs" = "${pkgs.bcachefs-tools}/bin/mount.bcachefs";
      };
      boot.initrd.extraUtilsCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
        copy_bin_and_libs ${pkgs.bcachefs-tools}/bin/bcachefs
        copy_bin_and_libs ${pkgs.bcachefs-tools}/bin/mount.bcachefs
        copy_bin_and_libs ${askPass}/bin/bcachefs-askpass
        sed -i s,/bin/sh,$out/bin/sh, $out/bin/bcachefs-askpass
      '';
      boot.initrd.extraUtilsCommandsTest = lib.mkIf (!config.boot.initrd.systemd.enable) ''
        $out/bin/bcachefs version
      '';

      boot.initrd.preFailCommands = lib.mkIf (!config.boot.initrd.systemd.enable) postCommands;
      boot.initrd.postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) (commonFunctions + preCommands + lib.concatStrings (lib.mapAttrsToList openCommand bootFs) + postCommands);

      boot.initrd.systemd.services = lib.mapAttrs' (mkUnits "/sysroot") bootFs;
    })
  ]);
}
