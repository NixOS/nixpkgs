{ config, lib, pkgs, ... }:

with lib;

let
  luks = config.boot.initrd.luks;

  openCommand = name': { name, device, header, keyFile, keyFileSize, allowDiscards, yubikey, ... }: assert name' == name; ''

    # Wait for a target (e.g. device, keyFile, header, ...) to appear.
    wait_target() {
        local name="$1"
        local target="$2"

        if [ ! -e $target ]; then
            echo -n "Waiting 10 seconds for $name $target to appear"
            local success=false;
            for try in $(seq 10); do
                echo -n "."
                sleep 1
                if [ -e $target ]; then success=true break; fi
            done
            if [ $success = true ]; then
                echo " - success";
            else
                echo " - failure";
            fi
        fi
    }

    # Wait for luksRoot (and optionally keyFile and/or header) to appear, e.g.
    # if on a USB drive.
    wait_target "device" ${device}

    ${optionalString (keyFile != null) ''
      wait_target "key file" ${keyFile}
    ''}

    ${optionalString (header != null) ''
      wait_target "header" ${header}
    ''}

    open_normally() {
        echo luksOpen ${device} ${name} ${optionalString allowDiscards "--allow-discards"} \
          ${optionalString (header != null) "--header=${header}"} \
          ${optionalString (keyFile != null) "--key-file=${keyFile} ${optionalString (keyFileSize != null) "--keyfile-size=${toString keyFileSize}"}"} \
          > /.luksopen_args
        cryptsetup-askpass
        rm /.luksopen_args
    }

    ${optionalString (luks.yubikeySupport && (yubikey != null)) ''

    rbtohex() {
        ( od -An -vtx1 | tr -d ' \n' )
    }

    hextorb() {
        ( tr '[:lower:]' '[:upper:]' | sed -e 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/gI' | xargs printf )
    }

    open_yubikey() {

        # Make all of these local to this function
        # to prevent their values being leaked
        local salt
        local iterations
        local k_user
        local challenge
        local response
        local k_luks
        local opened
        local new_salt
        local new_iterations
        local new_challenge
        local new_response
        local new_k_luks

        mkdir -p ${yubikey.storage.mountPoint}
        mount -t ${yubikey.storage.fsType} ${toString yubikey.storage.device} ${yubikey.storage.mountPoint}

        salt="$(cat ${yubikey.storage.mountPoint}${yubikey.storage.path} | sed -n 1p | tr -d '\n')"
        iterations="$(cat ${yubikey.storage.mountPoint}${yubikey.storage.path} | sed -n 2p | tr -d '\n')"
        challenge="$(echo -n $salt | openssl-wrap dgst -binary -sha512 | rbtohex)"
        response="$(ykchalresp -${toString yubikey.slot} -x $challenge 2>/dev/null)"

        for try in $(seq 3); do

            ${optionalString yubikey.twoFactor ''
            echo -n "Enter two-factor passphrase: "
            read -s k_user
            echo
            ''}

            if [ ! -z "$k_user" ]; then
                k_luks="$(echo -n $k_user | pbkdf2-sha512 ${toString yubikey.keyLength} $iterations $response | rbtohex)"
            else
                k_luks="$(echo | pbkdf2-sha512 ${toString yubikey.keyLength} $iterations $response | rbtohex)"
            fi

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

        echo -n "Gathering entropy for new salt (please enter random keys to generate entropy if this blocks for long)..."
        for i in $(seq ${toString yubikey.saltLength}); do
            byte="$(dd if=/dev/random bs=1 count=1 2>/dev/null | rbtohex)";
            new_salt="$new_salt$byte";
            echo -n .
        done;
        echo "ok"

        new_iterations="$iterations"
        ${optionalString (yubikey.iterationStep > 0) ''
        new_iterations="$(($new_iterations + ${toString yubikey.iterationStep}))"
        ''}

        new_challenge="$(echo -n $new_salt | openssl-wrap dgst -binary -sha512 | rbtohex)"

        new_response="$(ykchalresp -${toString yubikey.slot} -x $new_challenge 2>/dev/null)"

        if [ ! -z "$k_user" ]; then
            new_k_luks="$(echo -n $k_user | pbkdf2-sha512 ${toString yubikey.keyLength} $new_iterations $new_response | rbtohex)"
        else
            new_k_luks="$(echo | pbkdf2-sha512 ${toString yubikey.keyLength} $new_iterations $new_response | rbtohex)"
        fi

        mkdir -p ${yubikey.ramfsMountPoint}
        # A ramfs is used here to ensure that the file used to update
        # the key slot with cryptsetup will never get swapped out.
        # Warning: Do NOT replace with tmpfs!
        mount -t ramfs none ${yubikey.ramfsMountPoint}

        echo -n "$new_k_luks" | hextorb > ${yubikey.ramfsMountPoint}/new_key
        echo -n "$k_luks" | hextorb | cryptsetup luksChangeKey ${device} --key-file=- ${yubikey.ramfsMountPoint}/new_key

        if [ $? == "0" ]; then
            echo -ne "$new_salt\n$new_iterations" > ${yubikey.storage.mountPoint}${yubikey.storage.path}
        else
            echo "Warning: Could not update LUKS key, current challenge persists!"
        fi

        rm -f ${yubikey.ramfsMountPoint}/new_key
        umount ${yubikey.ramfsMountPoint}
        rm -rf ${yubikey.ramfsMountPoint}

        umount ${yubikey.storage.mountPoint}
    }

    ${optionalString (yubikey.gracePeriod > 0) ''
    echo -n "Waiting ${toString yubikey.gracePeriod} seconds as grace..."
    for i in $(seq ${toString yubikey.gracePeriod}); do
        sleep 1
        echo -n .
    done
    echo "ok"
    ''}

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

  preLVM = filterAttrs (n: v: v.preLVM) luks.devices;
  postLVM = filterAttrs (n: v: !v.preLVM) luks.devices;

in
{

  options = {

    boot.initrd.luks.mitigateDMAAttacks = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Unless enabled, encryption keys can be easily recovered by an attacker with physical
        access to any machine with PCMCIA, ExpressCard, ThunderBolt or FireWire port.
        More information is available at <link xlink:href="http://en.wikipedia.org/wiki/DMA_attack"/>.

        This option blacklists FireWire drivers, but doesn't remove them. You can manually
        load the drivers if you need to use a FireWire device, but don't forget to unload them!
      '';
    };

    boot.initrd.luks.cryptoModules = mkOption {
      type = types.listOf types.str;
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
      default = { };
      example = { "luksroot".device = "/dev/disk/by-uuid/430e9eff-d852-4f68-aa3b-2fa3599ebe08"; };
      description = ''
        The encrypted disk that should be opened before the root
        filesystem is mounted. Both LVM-over-LUKS and LUKS-over-LVM
        setups are supported. The unencrypted devices can be accessed as
        <filename>/dev/mapper/<replaceable>name</replaceable></filename>.
      '';

      type = with types; loaOf (submodule (
        { name, ... }: { options = {

          name = mkOption {
            visible = false;
            default = name;
            example = "luksroot";
            type = types.str;
            description = "Name of the unencrypted device in <filename>/dev/mapper</filename>.";
          };

          device = mkOption {
            example = "/dev/disk/by-uuid/430e9eff-d852-4f68-aa3b-2fa3599ebe08";
            type = types.str;
            description = "Path of the underlying encrypted block device.";
          };

          header = mkOption {
            default = null;
            example = "/root/header.img";
            type = types.nullOr types.str;
            description = ''
              The name of the file or block device that
              should be used as header for the encrypted device.
            '';
          };

          keyFile = mkOption {
            default = null;
            example = "/dev/sdb1";
            type = types.nullOr types.str;
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

          # FIXME: get rid of this option.
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
              has security implications; please read the LUKS documentation before
              activating it.
            '';
          };

          yubikey = mkOption {
            default = null;
            description = ''
              The options to use for this LUKS device in Yubikey-PBA.
              If null (the default), Yubikey-PBA will be disabled for this device.
            '';

            type = with types; nullOr (submodule {
              options = {
                twoFactor = mkOption {
                  default = true;
                  type = types.bool;
                  description = "Whether to use a passphrase and a Yubikey (true), or only a Yubikey (false).";
                };

                slot = mkOption {
                  default = 2;
                  type = types.int;
                  description = "Which slot on the Yubikey to challenge.";
                };

                saltLength = mkOption {
                  default = 16;
                  type = types.int;
                  description = "Length of the new salt in byte (64 is the effective maximum).";
                };

                keyLength = mkOption {
                  default = 64;
                  type = types.int;
                  description = "Length of the LUKS slot key derived with PBKDF2 in byte.";
                };

                iterationStep = mkOption {
                  default = 0;
                  type = types.int;
                  description = "How much the iteration count for PBKDF2 is increased at each successful authentication.";
                };

                gracePeriod = mkOption {
                  default = 2;
                  type = types.int;
                  description = "Time in seconds to wait before attempting to find the Yubikey.";
                };

                ramfsMountPoint = mkOption {
                  default = "/crypt-ramfs";
                  type = types.str;
                  description = "Path where the ramfs used to update the LUKS key will be mounted during early boot.";
                };

                /* TODO: Add to the documentation of the current module:

                   Options related to the storing the salt.
                */
                storage = {
                  device = mkOption {
                    default = "/dev/sda1";
                    type = types.path;
                    description = ''
                      An unencrypted device that will temporarily be mounted in stage-1.
                      Must contain the current salt to create the challenge for this LUKS device.
                    '';
                  };

                  fsType = mkOption {
                    default = "vfat";
                    type = types.str;
                    description = "The filesystem of the unencrypted device.";
                  };

                  mountPoint = mkOption {
                    default = "/crypt-storage";
                    type = types.str;
                    description = "Path where the unencrypted device will be mounted during early boot.";
                  };

                  path = mkOption {
                    default = "/crypt-storage/default";
                    type = types.str;
                    description = ''
                      Absolute path of the salt on the unencrypted device with
                      that device's root directory as "/".
                    '';
                  };
                };
              };
            });
          };

        }; }));
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

  config = mkIf (luks.devices != {}) {

    # actually, sbp2 driver is the one enabling the DMA attack, but this needs to be tested
    boot.blacklistedKernelModules = optionals luks.mitigateDMAAttacks
      ["firewire_ohci" "firewire_core" "firewire_sbp2"];

    # Some modules that may be needed for mounting anything ciphered
    boot.initrd.availableKernelModules = [ "dm_mod" "dm_crypt" "cryptd" ] ++ luks.cryptoModules;

    # copy the cryptsetup binary and it's dependencies
    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.cryptsetup}/bin/cryptsetup

      cat > $out/bin/cryptsetup-askpass <<EOF
      #!$out/bin/sh -e
      if [ -e /.luksopen_args ]; then
        cryptsetup \$(cat /.luksopen_args)
        killall -q cryptsetup
      else
        echo "Passphrase is not requested now"
        exit 1
      fi
      EOF
      chmod +x $out/bin/cryptsetup-askpass

      ${optionalString luks.yubikeySupport ''
        copy_bin_and_libs ${pkgs.yubikey-personalization}/bin/ykchalresp
        copy_bin_and_libs ${pkgs.yubikey-personalization}/bin/ykinfo
        copy_bin_and_libs ${pkgs.openssl.bin}/bin/openssl

        cc -O3 -I${pkgs.openssl.dev}/include -L${pkgs.openssl.out}/lib ${./pbkdf2-sha512.c} -o pbkdf2-sha512 -lcrypto
        strip -s pbkdf2-sha512
        copy_bin_and_libs pbkdf2-sha512

        mkdir -p $out/etc/ssl
        cp -pdv ${pkgs.openssl.out}/etc/ssl/openssl.cnf $out/etc/ssl

        cat > $out/bin/openssl-wrap <<EOF
        #!$out/bin/sh
        export OPENSSL_CONF=$out/etc/ssl/openssl.cnf
        $out/bin/openssl "\$@"
        EOF
        chmod +x $out/bin/openssl-wrap
      ''}
    '';

    boot.initrd.extraUtilsCommandsTest = ''
      $out/bin/cryptsetup --version
      ${optionalString luks.yubikeySupport ''
        $out/bin/ykchalresp -V
        $out/bin/ykinfo -V
        $out/bin/openssl-wrap version
      ''}
    '';

    boot.initrd.preLVMCommands = concatStrings (mapAttrsToList openCommand preLVM);
    boot.initrd.postDeviceCommands = concatStrings (mapAttrsToList openCommand postLVM);

    environment.systemPackages = [ pkgs.cryptsetup ];
  };
}
