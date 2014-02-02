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
        od -An -vtx1 | tr -d ' \n'
    }

    hextorb() {
        tr '[:lower:]' '[:upper:]' | sed -e 's|\([0-9A-F]\{2\}\)|\\\\\\x\1|gI' | xargs printf
    }

    take() {
        local c="$1"
        shift
        head -c $c "$@"
    }

    drop() {
        local c="$1"
        shift
        if [ -e "$1" ]; then
            cat "$1" | ( dd of=/dev/null bs="$c" count=1 2>/dev/null ; dd 2>/dev/null )
        else
            ( dd of=/dev/null bs="$c" count=1 2>/dev/null ; dd 2>/dev/null )
        fi
    }

    open_yubikey() {

        mkdir -p ${yubikey.storage.mountPoint}
        mount -t ${yubikey.storage.fsType} ${toString yubikey.storage.device} ${yubikey.storage.mountPoint}

        local uuid_r
        local k_user
        local challenge
        local k_blob
        local aes_blob_decrypted
        local checksum_correct
        local checksum
        local uuid_luks
        local user_record

        uuid_luks="$(cryptsetup luksUUID ${device} | take 36 | tr -d '-')"

        ${optionalString (!yubikey.multiUser) ''
        user_record="$(cat ${yubikey.storage.mountPoint}${yubikey.storage.path})"
        uuid_r="$(echo -n $user_record | take 32)"
        ''}

        for try in $(seq 3); do

            ${optionalString yubikey.multiUser ''
            local user_id
            echo -n "Enter user id: "
            read -s user_id
            echo
            ''}

            ${optionalString yubikey.twoFactor ''
            echo -n "Enter two-factor passphrase: "
            read -s k_user
            echo
            ''}

            ${optionalString yubikey.multiUser ''
            local user_id_hash
            user_id_hash="$(echo -n $user_id | openssl-wrap dgst -binary -sha512 | rbtohex)"

            user_record="$(sed -n -e /^$user_id_hash[^$]*$/p ${yubikey.storage.mountPoint}${yubikey.storage.path} | tr -d '\n')"

            if [ ! -z "$user_record" ]; then
                user_record="$(echo -n $user_record | drop 128)"
                uuid_r="$(echo -n $user_record | take 32)"
            ''}

                challenge="$(echo -n $k_user$uuid_r$uuid_luks | openssl-wrap dgst -binary -sha1 | rbtohex)"

                k_blob="$(ykchalresp -${toString yubikey.slot} -x $challenge 2>/dev/null)"

                aes_blob_decrypted="$(echo -n $user_record | drop 32 | hextorb | openssl-wrap enc -d -aes-256-ctr -K $k_blob -iv $uuid_r | rbtohex)"

                checksum="$(echo -n $aes_blob_decrypted | drop 168)"
                if [ "$(echo -n $aes_blob_decrypted | hextorb | take 84 | openssl-wrap dgst -binary -sha512 | rbtohex)" == "$checksum" ]; then
                    checksum_correct=1
                    break
                else
                    checksum_correct=0
                    echo "Authentication failed!"
                fi

            ${optionalString yubikey.multiUser ''
            else
                checksum_correct=0
                echo "Authentication failed!"
            fi
            ''}
        done

        if [ "$checksum_correct" != "1" ]; then
            umount ${yubikey.storage.mountPoint}
            echo "Maximum authentication errors reached"
            exit 1
        fi

        local k_yubi
        k_yubi="$(echo -n $aes_blob_decrypted | take 40)"

        local k_luks
        k_luks="$(echo -n $aes_blob_decrypted | drop 40 | take 128)"

        echo -n "$k_luks" | hextorb | cryptsetup luksOpen ${device} ${name} ${optionalString allowDiscards "--allow-discards"} --key-file=-

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
            new_uuid_r="$(echo -n $new_uuid_r | take 36 | tr -d '-')"

            local new_challenge
            new_challenge="$(echo -n $k_user$new_uuid_r$uuid_luks | openssl-wrap dgst -binary -sha1 | rbtohex)"

            local new_k_blob
            new_k_blob="$(echo -n $new_challenge | hextorb | openssl-wrap dgst -binary -sha1 -mac HMAC -macopt hexkey:$k_yubi | rbtohex)"

            local new_aes_blob
            new_aes_blob=$(echo -n "$k_yubi$k_luks$checksum" | hextorb | openssl-wrap enc -e -aes-256-ctr -K "$new_k_blob" -iv "$new_uuid_r" | rbtohex)

            ${optionalString yubikey.multiUser ''
            sed -i -e "s|^$user_id_hash$user_record|$user_id_hash$new_uuid_r$new_aes_blob|1"
            ''}

            ${optionalString (!yubikey.multiUser) ''
            echo -n "$new_uuid_r$new_aes_blob" > ${yubikey.storage.mountPoint}${yubikey.storage.path}
            ''}
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

            multiUser = mkOption {
              default = false;
              type = types.bool;
              description = "Whether to allow multiple users to authenticate with a Yubikey";
            };

            slot = mkOption {
              default = 2;
              type = types.int;
              description = "Which slot on the Yubikey to challenge";
            };

            storage = mkOption {
              type = types.optionSet;
              description = "Options related to the authentication record";

              options = {
                device = mkOption {
                  default = /dev/sda1;
                  type = types.path;
                  description = ''
                    An unencrypted device that will temporarily be mounted in stage-1.
                    Must contain the authentication record for this LUKS device.
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
                    Absolute path of the authentication record on the unencrypted device with
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
