{ config, lib, pkgs, utils, ... }:

with lib;

let

  bootFs = filterAttrs (n: fs: (fs.fsType == "bcachefs") && (utils.fsNeededForBoot fs)) config.fileSystems;

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
  firstDevice = fs: head (splitString ":" fs.device);

  openCommand = name: fs: ''
    tryUnlock ${name} ${firstDevice fs}
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

in

{
  config = mkIf (elem "bcachefs" config.boot.supportedFilesystems) (mkMerge [
    {
      # needed for systemd-remount-fs
      system.fsPackages = [ pkgs.bcachefs-tools ];

      # use kernel package with bcachefs support until it's in mainline
      # TODO replace with requireKernelConfig
      boot.kernelPackages = pkgs.linuxPackages_testing_bcachefs;

      systemd.services = lib.mapAttrs' (mkUnits "") (lib.filterAttrs (n: fs: (fs.fsType == "bcachefs") && (!utils.fsNeededForBoot fs)) config.fileSystems);
    }

    (mkIf ((elem "bcachefs" config.boot.initrd.supportedFilesystems) || (bootFs != {})) {
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
      '';
      boot.initrd.extraUtilsCommandsTest = lib.mkIf (!config.boot.initrd.systemd.enable) ''
        $out/bin/bcachefs version
      '';

      boot.initrd.postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) (commonFunctions + concatStrings (mapAttrsToList openCommand bootFs));

      boot.initrd.systemd.services = lib.mapAttrs' (mkUnits "/sysroot") bootFs;
    })
  ]);
}
