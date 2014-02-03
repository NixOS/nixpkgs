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

    open_normally() {
        cryptsetup luksOpen ${device} ${name} ${optionalString allowDiscards "--allow-discards"} \
          ${optionalString (keyFile != null) "--key-file=${keyFile} ${optionalString (keyFileSize != null) "--keyfile-size=${toString keyFileSize}"}"}
    }

    ${optionalString (luks.yubikeySupport && (yubikey != null)) ''

    rbtohex() {
        ( od -An -vtx1 | tr -d ' \n' )
    }

    hextorb() {
        ( tr '[:lower:]' '[:upper:]' | sed -e 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/gI'| xargs printf )
    }

    open_yubikey() {

        mkdir -p ${yubikey.storage.mountPoint}
        mount -t ${yubikey.storage.fsType} ${toString yubikey.storage.device} ${yubikey.storage.mountPoint}

        local uuid_r
        local k_user
        local challenge
        local opened

        sleep 1

        uuid_r="$(cat ${yubikey.storage.mountPoint}${yubikey.storage.path})"

        for try in $(seq 3); do

            ${optionalString yubikey.twoFactor ''
            echo -n "Enter two-factor passphrase: "
            read -s k_user
            echo
            ''}

            challenge="$(echo -n $k_user$uuid_r | openssl-wrap dgst -binary -sha512 | rbtohex)"

            k_luks="$(ykchalresp -${toString yubikey.slot} -x $challenge 2>/dev/null)"

            echo -n "$k_luks" | hextorb | cryptsetup luksOpen ${device} ${name} ${optionalString allowDiscards "--allow-discards"} --key-file=-

            if [ $? == "0" ]; then
                opened=true
                break
            else
                opened=false
                echo "Authentication failed!"
            fi
        done

        if [ "$opened" == false ]; then
            umount ${yubikey.storage.mountPoint}
            echo "Maximum authentication errors reached"
            exit 1
        fi

        update_failed=false

        local new_uuid_r
        new_uuid_r="$(uuidgen)"
        if [ $? != "0" ]; then
            for try in $(seq 10); do
                sleep 1
                new_uuid_r="$(uuidgen)"
                if [ $? == "0" ]; then break; fi
                if [ $try -eq 10 ]; then update_failed=true; fi
            done
        fi

        if [ "$update_failed" == false ]; then
            new_uuid_r="$(echo -n $new_uuid_r | head -c 36 | tr -d '-')"

            local new_challenge
            new_challenge="$(echo -n $k_user$new_uuid_r | openssl-wrap dgst -binary -sha512 | rbtohex)"

            local new_k_luks
            new_k_luks="$(ykchalresp -${toString yubikey.slot} -x $new_challenge 2>/dev/null)"

            mkdir -p ${yubikey.ramfsMountPoint}
            # A ramfs is used here to ensure that the file used to update
            # the key slot with cryptsetup will never get swapped out.
            # Warning: Do NOT replace with tmpfs!
            mount -t ramfs none ${yubikey.ramfsMountPoint}

            echo -n "$new_k_luks" | hextorb > ${yubikey.ramfsMountPoint}/new_key
            echo -n "$k_luks" | cryptsetup luksChangeKey ${device} --key-file=- ${yubikey.ramfsMountPoint}/new_key

            if [ $? == "0" ]; then
                echo -n "$new_uuid_r" > ${yubikey.storage.mountPoint}${yubikey.storage.path}
            else
                echo "Warning: Could not update LUKS key, current challenge persists!"
            fi

            rm -f ${yubikey.ramfsMountPoint}/new_key
            umount ${yubikey.ramfsMountPoint}
            rm -rf ${yubikey.ramfsMountPoint}
        else
            echo "Warning: Could not obtain new UUID, current challenge persists!"
        fi

        umount ${yubikey.storage.mountPoint}
    }

    yubikey_missing=true
    ykinfo -v 1>/dev/null 2>&1
    if [ $? != "0" ]; then
        echo -n "waiting 10 seconds for yubikey to appear..."
        for try in $(seq 10); do
            sleep 1
            ykinfo -v 1>/dev/null 2>&1
            if [ $? == "0" ]; then
                yubikey_missing=false
                break
            fi
            echo -n .
        done
        echo "ok"
    else
        yubikey_missing=false
    fi

    if [ "$yubikey_missing" == true ]; then
        echo "no yubikey found, falling back to non-yubikey open procedure"
        open_normally
    else
        open_yubikey
    fi
    ''}

    # open luksRoot and scan for logical volumes
    ${optionalString ((!luks.yubikeySupport) || (yubikey == null)) ''
    open_normally
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
          description = ''
            The options to use for this LUKS device in Yubikey-PBA.
            If null (the default), Yubikey-PBA will be disabled for this device.
          '';

          options = {
            twoFactor = mkOption {
              default = true;
              type = types.bool;
              description = "Whether to use a passphrase and a Yubikey (true), or only a Yubikey (false)";
            };

            slot = mkOption {
              default = 2;
              type = types.int;
              description = "Which slot on the Yubikey to challenge";
            };

            ramfsMountPoint = mkOption {
              default = "/crypt-ramfs";
              type = types.string;
              description = "Path where the ramfs used to update the LUKS key will be mounted in stage-1";
            };

            storage = mkOption {
              type = types.optionSet;
              description = "Options related to the storing the random UUID";

              options = {
                device = mkOption {
                  default = /dev/sda1;
                  type = types.path;
                  description = ''
                    An unencrypted device that will temporarily be mounted in stage-1.
                    Must contain the current random UUID to create the challenge for this LUKS device.
                  '';
                };

                fsType = mkOption {
                  default = "vfat";
                  type = types.string;
                  description = "The filesystem of the unencrypted device";
                };

                mountPoint = mkOption {
                  default = "/crypt-storage";
                  type = types.string;
                  description = "Path where the unencrypted device will be mounted in stage-1";
                };

                path = mkOption {
                  default = "/crypt-storage/default";
                  type = types.string;
                  description = ''
                    Absolute path of the random UUID on the unencrypted device with
                    that device's root directory as "/".
                  '';
                };
              };
            };
          };
        };

      };
    };

    boot.initrd.luks.yubikeySupport = mkOption {
      default = false;
      type = types.bool;
      description = ''
            Enables support for authenticating with a Yubikey on LUKS devices.
            See the NixOS wiki for information on how to properly setup a LUKS device
            and a Yubikey to work with this feature.
          '';
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

      cp -pdv ${pkgs.libgcrypt}/lib/libgcrypt*.so.* $out/lib
      cp -pdv ${pkgs.libgpgerror}/lib/libgpg-error*.so.* $out/lib
      cp -pdv ${pkgs.cryptsetup}/lib/libcryptsetup*.so.* $out/lib
      cp -pdv ${pkgs.popt}/lib/libpopt*.so.* $out/lib

      ${optionalString luks.yubikeySupport ''
      cp -pdv ${pkgs.utillinux}/bin/uuidgen $out/bin
      cp -pdv ${pkgs.ykpers}/bin/ykchalresp $out/bin
      cp -pdv ${pkgs.ykpers}/bin/ykinfo $out/bin
      cp -pdv ${pkgs.openssl}/bin/openssl $out/bin

      cp -pdv ${pkgs.libusb1}/lib/libusb*.so.* $out/lib
      cp -pdv ${pkgs.ykpers}/lib/libykpers*.so.* $out/lib
      cp -pdv ${pkgs.libyubikey}/lib/libyubikey*.so.* $out/lib
      cp -pdv ${pkgs.openssl}/lib/libssl*.so.* $out/lib
      cp -pdv ${pkgs.openssl}/lib/libcrypto*.so.* $out/lib

      mkdir -p $out/etc/ssl
      cp -pdv ${pkgs.openssl}/etc/ssl/openssl.cnf $out/etc/ssl

      cat > $out/bin/openssl-wrap <<EOF
#!$out/bin/sh
EOF
      chmod +x $out/bin/openssl-wrap
      ''}
    '';

    boot.initrd.extraUtilsCommandsTest = ''
      $out/bin/cryptsetup --version
      ${optionalString luks.yubikeySupport ''
        $out/bin/uuidgen --version
        $out/bin/ykchalresp -V
        $out/bin/ykinfo -V
        cat > $out/bin/openssl-wrap <<EOF
#!$out/bin/sh
export OPENSSL_CONF=$out/etc/ssl/openssl.cnf
$out/bin/openssl "\$@"
EOF
        $out/bin/openssl-wrap version
      ''}
    '';

    boot.initrd.preLVMCommands = concatMapStrings openCommand preLVM;
    boot.initrd.postDeviceCommands = concatMapStrings openCommand postLVM;

    environment.systemPackages = [ pkgs.cryptsetup ];
  };
}
