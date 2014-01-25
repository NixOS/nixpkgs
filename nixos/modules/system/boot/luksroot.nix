{ config, pkgs, ... }:

with pkgs.lib;

let
  luks = config.boot.initrd.luks;

  openCommand = { name, device, keyFile, keyFileSize, allowDiscards, yubikey, ... }: ''
    # Wait for luksRoot to appear, e.g. if on a usb drive.
    # XXX: copied and adapted from stage-1-init.sh - should be
    # available as a function.
    if ! test -e ${device}; then
        echo -n "waiting 10 seconds for device ${device} to appear..."
        for try in $(seq 10); do
            sleep 1
            if test -e ${device}; then break; fi
            echo -n .
        done
        echo "ok"
    fi

    ${optionalString (keyFile != null) ''
    if ! test -e ${keyFile}; then
        echo -n "waiting 10 seconds for key file ${keyFile} to appear..."
        for try in $(seq 10); do
            sleep 1
            if test -e ${keyFile}; then break; fi
            echo -n .
        done
        echo "ok"
    fi
    ''}

    ${optionalString (luks.yubikeySupport && (yubikey != null)) ''
    mkdir -p ${yubikey.challenge.mountPoint}
    mount -t ${yubikey.challenge.fsType} ${toString yubikey.challenge.device} ${yubikey.challenge.mountPoint}
    response="$(ykchalresp -${toString yubikey.yubikeySlot} "`cat ${yubikey.challenge.mountPoint}${yubikey.challenge.file}`" 2>/dev/null || true)"
    if [ -z "$response" ]; then
        echo -n "waiting 10 seconds for yubikey to appear..."
        for try in $(seq 10); do
            sleep 1
            response="$(ykchalresp -${toString yubikey.yubikeySlot} "`cat ${yubikey.challenge.mountPoint}${yubikey.challenge.file}`" 2>/dev/null || true)"
            if [ ! -z "$response" ]; then break; fi
            echo -n .
        done
        echo "ok"
    fi

    ${optionalString yubikey.twoFactor ''
    if [ ! -z "$response" ]; then
        echo -n "Enter two-factor passphrase: "
        read -s passphrase
        current_key="$passphrase$response"
    fi
    ''}

    ${optionalString (!yubikey.twoFactor) ''
    if [ ! -z "$response" ]; then
        current_key="$response"
    fi
    ''}
    ''}

    # open luksRoot and scan for logical volumes
    ${optionalString ((!luks.yubikeySupport) || (yubikey == null)) ''
    cryptsetup luksOpen ${device} ${name} ${optionalString allowDiscards "--allow-discards"} \
      ${optionalString (keyFile != null) "--key-file=${keyFile} ${optionalString (keyFileSize != null) "--keyfile-size=${toString keyFileSize}"}"}
    ''}

    ${optionalString (luks.yubikeySupport && (yubikey != null)) ''
    if [ -z "$response" ]; then
        cryptsetup luksOpen ${device} ${name} ${optionalString allowDiscards "--allow-discards"} \
          ${optionalString (keyFile != null) "--key-file=${keyFile} ${optionalString (keyFileSize != null) "--keyfile-size=${toString keyFileSize}"}"}
    else
        echo $current_key | cryptsetup luksOpen ${device} ${name} ${optionalString allowDiscards "--allow-discards"} --key-file=-

        if [ $? != "0" ]; then
            for try in $(seq 3); do

                ${optionalString (!yubikey.twoFactor) ''
                sleep 1
                ''}

                ${optionalString yubikey.twoFactor ''
                echo -n "Enter two-factor passphrase: "
                read -s passphrase
                current_key="$passphrase$response"
                ''}

                echo $current_key | cryptsetup luksOpen ${device} ${name} ${optionalString allowDiscards "--allow-discards"} --key-file=-
                if [ $? == "0" ]; then break; fi
                echo -n .
            done
        fi

        mkdir -p ${yubikey.ramfsMountPoint}
        # A ramfs is used here to ensure that the file used to update
        # the key slot with cryptsetup will never get swapped out.
        # Warning: Do NOT replace with tmpfs!
        mount -t ramfs none ${yubikey.ramfsMountPoint}

        update_failed=false
        old_challenge=$(cat ${yubikey.challenge.mountPoint}${yubikey.challenge.file})

        new_challenge=$(uuidgen)
        if [ $? != "0" ]; then
            for try in $(seq 10); do
                sleep 1
                new_challenge=$(uuidgen)
                if [ $? == "0" ]; then break; fi
                if [ $try -eq 10 ]; then update_failed=true; fi
            done
        fi

        if [ "$update_failed" == false ]; then
            echo $new_challenge > ${yubikey.challenge.mountPoint}${yubikey.challenge.file}
            response="$(ykchalresp -${toString yubikey.yubikeySlot} "`cat ${yubikey.challenge.mountPoint}${yubikey.challenge.file}`" 2>/dev/null || true)"
            if [ -z "$response" ]; then
                echo -n "waiting 10 seconds for yubikey to appear..."
                for try in $(seq 10); do
                    sleep 1
                    response="$(ykchalresp -${toString yubikey.yubikeySlot} "`cat ${yubikey.challenge.mountPoint}${yubikey.challenge.file}`" 2>/dev/null || true)"
                    if [ ! -z "$response" ]; then break; fi
                    echo -n .
                done
                echo "ok";
            fi

            if [ ! -z "$response" ]; then
                ${optionalString yubikey.twoFactor ''
                new_key="$passphrase$response"
                ''}

                ${optionalString (!yubikey.twoFactor) ''
                new_key="$response"
                ''}

                echo $new_key > ${yubikey.ramfsMountPoint}/new_key

                echo $current_key | cryptsetup luksChangeKey ${device} --key-file=- --key-slot ${toString yubikey.luksKeySlot} ${yubikey.ramfsMountPoint}/new_key
                if [ $? != "0" ]; then
                    for try in $(seq 10); do
                        sleep 1
                        echo $current_key | cryptsetup luksChangeKey ${device} --key-file=- --key-slot ${toString yubikey.luksKeySlot} ${yubikey.ramfsMountPoint}/new_key
                        if [ $? == "0" ]; then break; fi
                        if [ $try -eq 10 ]; then update_failed=true; fi
                    done

                fi

                rm -f ${yubikey.ramfsMountPoint}/new_key

                if [ "$update_failed" == true ]; then
                    echo $old_challenge > ${yubikey.challenge.mountPoint}${yubikey.challenge.file}
                    echo "Warning: Could not update luks header with new key for ${device}, old challenge restored!"
                fi
            else
              echo $old_challenge > ${yubikey.challenge.mountPoint}${yubikey.challenge.file}
              echo "Warning: No yubikey present to challenge for ${device}, old challenge restored!"
            fi
        else
            echo "Warning: New challenge could not be obtained for ${device}, old challenge persists!"
        fi

        umount ${yubikey.ramfsMountPoint}
        umount ${yubikey.challenge.mountPoint}
    fi
    ''}
  '';

  isPreLVM = f: f.preLVM;
  preLVM = filter isPreLVM luks.devices;
  postLVM = filter (f: !(isPreLVM f)) luks.devices;

in
{

  options = {

    boot.initrd.luks.mitigateDMAAttacks = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Unless enabled, encryption keys can be easily recovered by an attacker with physical
        access to any machine with PCMCIA, ExpressCard, ThunderBolt or FireWire port.
        More information: http://en.wikipedia.org/wiki/DMA_attack

        This option blacklists FireWire drivers, but doesn't remove them. You can manually
        load the drivers if you need to use a FireWire device, but don't forget to unload them!
      '';
    };

    boot.initrd.luks.cryptoModules = mkOption {
      type = types.listOf types.string;
      default =
        [ "aes" "aes_generic" "blowfish" "twofish"
          "serpent" "cbc" "xts" "lrw" "sha1" "sha256" "sha512"
          (if pkgs.stdenv.system == "x86_64-linux" then "aes_x86_64" else "aes_i586")
        ];
      description = ''
        A list of cryptographic kernel modules needed to decrypt the root device(s).
        The default includes all common modules.
      '';
    };

    boot.initrd.luks.devices = mkOption {
      default = [ ];
      example = [ { name = "luksroot"; device = "/dev/sda3"; preLVM = true; } ];
      description = ''
        The list of devices that should be decrypted using LUKS before trying to mount the
        root partition. This works for both LVM-over-LUKS and LUKS-over-LVM setups.

        The devices are decrypted to the device mapper names defined.

        Make sure that initrd has the crypto modules needed for decryption.
      '';

      type = types.listOf types.optionSet;

      options = {

        name = mkOption {
          example = "luksroot";
          type = types.string;
          description = "Named to be used for the generated device in /dev/mapper.";
        };

        device = mkOption {
          example = "/dev/sda2";
          type = types.string;
          description = "Path of the underlying block device.";
        };

        keyFile = mkOption {
          default = null;
          example = "/dev/sdb1";
          type = types.nullOr types.string;
          description = ''
            The name of the file (can be a raw device or a partition) that
            should be used as the decryption key for the encrypted device. If
            not specified, you will be prompted for a passphrase instead.
          '';
        };

        keyFileSize = mkOption {
          default = null;
          example = 4096;
          type = types.nullOr types.int;
          description = ''
            The size of the key file. Use this if only the beginning of the
            key file should be used as a key (often the case if a raw device
            or partition is used as key file). If not specified, the whole
            <literal>keyFile</literal> will be used decryption, instead of just
            the first <literal>keyFileSize</literal> bytes.
          '';
        };

        preLVM = mkOption {
          default = true;
          type = types.bool;
          description = "Whether the luksOpen will be attempted before LVM scan or after it.";
        };

        allowDiscards = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Whether to allow TRIM requests to the underlying device. This option
            has security implications, please read the LUKS documentation before
            activating in.
          '';
        };

        yubikey = mkOption {
          default = null;
          type = types.nullOr types.optionSet;
          description = "TODO";

          options = {
            twoFactor = mkOption {
              default = false;
              type = types.bool;
              description = "TODO";
            };

            yubikeySlot = mkOption {
              default = 2;
              type = types.int;
              description = "TODO";
            };

            luksKeySlot = mkOption {
              default = 1;
              type = types.int;
              description = "TODO";
            };

            challenge = mkOption {
              type = types.optionSet;
              description = "TODO";

              options = {
                device = mkOption {
                  default = /dev/sda1;
                  type = types.path;
                  description = "TODO";
                };

                fsType = mkOption {
                  default = "vfat";
                  type = types.string;
                  description = "TODO";
                };

                mountPoint = mkOption {
                  default = "/crypt-challenge";
                  type = types.string;
                  description = "TODO";
                };

                file = mkOption {
                  default = "/crypt-challenge";
                  type = types.string;
                  description = "TODO";
                };
              };
            };

            ramfsMountPoint = mkOption {
              default = "/crypt-update";
              type = types.string;
              description = "TODO";
            };
          };
        };

      };
    };

    boot.initrd.luks.yubikeySupport = mkOption {
      default = false;
      type = types.bool;
      description = "TODO";
    };
  };

  config = mkIf (luks.devices != []) {

    # actually, sbp2 driver is the one enabling the DMA attack, but this needs to be tested
    boot.blacklistedKernelModules = optionals luks.mitigateDMAAttacks
      ["firewire_ohci" "firewire_core" "firewire_sbp2"];

    # Some modules that may be needed for mounting anything ciphered
    boot.initrd.availableKernelModules = [ "dm_mod" "dm_crypt" "cryptd" ] ++ luks.cryptoModules;

    # copy the cryptsetup binary and it's dependencies
    boot.initrd.extraUtilsCommands = ''
      cp -pdv ${pkgs.cryptsetup}/sbin/cryptsetup $out/bin
      # XXX: do we have a function that does this?
      for lib in $(ldd $out/bin/cryptsetup |grep '=>' |grep /nix/store/ |cut -d' ' -f3); do
        cp -pdvn $lib $out/lib
        cp -pvn $(readlink -f $lib) $out/lib
      done
      ${optionalString luks.yubikeySupport ''
      cp -pdv ${pkgs.utillinux}/bin/uuidgen $out/bin
      for lib in $(ldd $out/bin/uuidgen |grep '=>' |grep /nix/store/ |cut -d' ' -f3); do
        cp -pdvn $lib $out/lib
        cp -pvn $(readlink -f $lib) $out/lib
      done

      cp -pdv ${pkgs.ykpers}/bin/ykchalresp $out/bin
      for lib in $(ldd $out/bin/ykchalresp |grep '=>' |grep /nix/store/ |cut -d' ' -f3); do
        cp -pdvn $lib $out/lib
        cp -pvn $(readlink -f $lib) $out/lib
      done
      ''}
    '';

    boot.initrd.extraUtilsCommandsTest = ''
      $out/bin/cryptsetup --version
      ${optionalString luks.yubikeySupport ''
        $out/bin/uuidgen --version
        $out/bin/ykchalresp -V
      ''}
    '';

    boot.initrd.preLVMCommands = concatMapStrings openCommand preLVM;
    boot.initrd.postDeviceCommands = concatMapStrings openCommand postLVM;

    environment.systemPackages = [ pkgs.cryptsetup ];
  };
}
