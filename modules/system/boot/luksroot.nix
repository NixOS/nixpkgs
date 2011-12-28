{pkgs, config, ...}:

with pkgs.lib;

let
  luksRoot = config.boot.initrd.luksRoot;
in
{

  options = {

    boot.initrd.luksRoot = mkOption {
      default = "";
      example = "/dev/sda3";
      description = '';
        The device that should be decrypted using LUKS before trying to mount the
        root partition. This works for both LVM-over-LUKS and LUKS-over-LVM setups.

        Make sure that initrd has the crypto modules needed for decryption.

        The decrypted device name is /dev/mapper/luksroot.
      '';
    };

  };



  config = mkIf (luksRoot != "") {

    # copy the cryptsetup binary and it's dependencies
    boot.initrd.extraUtilsCommands = ''
      cp -pdv ${pkgs.cryptsetup}/sbin/cryptsetup $out/bin
      # XXX: do we have a function that does this?
      for lib in $(ldd $out/bin/cryptsetup |grep '=>' |grep /nix/store/ |cut -d' ' -f3); do
        cp -pdvn $lib $out/lib
        cp -pvn $(readlink -f $lib) $out/lib
      done
      ERROR_THAT_IS_NOT_CAUGHT_WHY_IS_OUR_QUEST_TO_FIND_OUT
    '';

    # test whether cryptsetup finds all dependencies and is at least
    # version 1.4.1
    boot.initrd.extraUtilsCommandsTest = ''
      cryptsetup_version=$($out/bin/cryptsetup --version |cut -d' ' -f2)
      if test $(echo $version |cut -d'.' -f1) -lt 1; then
        if test $(echo $version |cut -d'.' -f2) -lt 4; then
          if test $(echo $version |cut -d'.' -f3) -lt 2; then
            echo "Somehow the version of cryptsetup is too old: $cryptsetup_version instead of 1.4.1"
            exit 1
          fi
        fi
      fi
      unset cryptsetup_version
    '';

    boot.initrd.preLVMCommands = ''
      # Wait for luksRoot to appear, e.g. if on a usb drive.
      # XXX: copied and adapted from stage-1-init.sh - should be
      # available as a function.
      if ! test -e ${luksRoot}; then
          echo -n "waiting for device ${luksRoot} to appear..."
          for ((try = 0; try < 10; try++)); do
              sleep 1
              if test -e ${luksRoot}; then break; fi
              echo -n "."
          done
          echo "ok"
      fi
      # open luksRoot and scan for logical volumes
      cryptsetup luksOpen ${luksRoot} luksroot
    '';

  };

}
