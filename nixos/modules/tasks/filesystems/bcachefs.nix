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
        if bcachefs unlock -c $path > /dev/null 2> /dev/null; then    # test for encryption
            prompt $name
            until bcachefs unlock $path 2> /dev/null; do              # repeat until sucessfully unlocked
                printf "unlocking failed!\n"
                prompt $name
            done
            printf "unlocking successful.\n"
        fi
    }
  '';

  openCommand = name: fs:
    let
      # we need only unlock one device manually, and cannot pass multiple at once
      # remove this adaptation when bcachefs implements mounting by filesystem uuid
      # also, implement automatic waiting for the constituent devices when that happens
      # bcachefs does not support mounting devices with colons in the path, ergo we don't (see #49671)
      firstDevice = head (splitString ":" fs.device);
    in
      ''
        tryUnlock ${name} ${firstDevice}
      '';

in

{
  config = mkIf (elem "bcachefs" config.boot.supportedFilesystems) (mkMerge [
    {
      # We do not want to include bachefs in the fsPackages for systemd-initrd
      # because we provide the unwrapped version of mount.bcachefs
      # through the extraBin option, which will make it available for use.
      system.fsPackages = lib.optional (!config.boot.initrd.systemd.enable) pkgs.bcachefs-tools;
      environment.systemPackages = lib.optional (config.boot.initrd.systemd.enable) pkgs.bcachefs-tools;

      # use kernel package with bcachefs support until it's in mainline
      boot.kernelPackages = pkgs.linuxPackages_testing_bcachefs;
    }

    (mkIf ((elem "bcachefs" config.boot.initrd.supportedFilesystems) || (bootFs != {})) {
      # chacha20 and poly1305 are required only for decryption attempts
      boot.initrd.availableKernelModules = [ "bcachefs" "sha256" "chacha20" "poly1305" ];

      boot.initrd.systemd.extraBin = {
        "bcachefs" = "${pkgs.bcachefs-tools}/bin/bcachefs";
        "mount.bcachefs" = pkgs.runCommand "mount.bcachefs" {} ''
          cp -pdv ${pkgs.bcachefs-tools}/bin/.mount.bcachefs.sh-wrapped $out
        '';
      };

      boot.initrd.extraUtilsCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
        copy_bin_and_libs ${pkgs.bcachefs-tools}/bin/bcachefs
      '';
      boot.initrd.extraUtilsCommandsTest = ''
        $out/bin/bcachefs version
      '';

      boot.initrd.postDeviceCommands = commonFunctions + concatStrings (mapAttrsToList openCommand bootFs);
    })
  ]);
}
