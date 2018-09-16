{ config, lib, pkgs, ... }:

with lib;

let
  luks = config.boot.initrd.luks;

  commonFunctions = ''
    die() {
      echo "$@" >&2
      exit 1
    }

    wait_target() {
        local name="$1"
        local target="$2"
        local secs="''${3:-10}"
        local desc="''${4:-$name $target to appear}"

        if [ ! -e $target ]; then
            echo -n "Waiting $secs seconds for $desc..."
            local success=false;
            for try in $(seq $secs); do
                echo -n "."
                sleep 1
                if [ -e $target ]; then
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

    wait_yubikey() {
      local secs="''${1:-10}"

      ykinfo -v 1>/dev/null 2>&1
      if [ $? != 0 ]; then
          echo -n "Waiting $secs seconds for Yubikey to appear..."
          local success=false
          for try in $(seq $secs); do
              echo -n .
              sleep 1
              ykinfo -v 1>/dev/null 2>&1
              if [ $? == 0 ]; then
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
  '';

  preCommands = ''
    # A place to store crypto things

    # A ramfs is used here to ensure that the file used to update
    # the key slot with cryptsetup will never get swapped out.
    # Warning: Do NOT replace with tmpfs!
    mkdir -p /crypt-ramfs
    mount -t ramfs none /crypt-ramfs

    # For Yubikey salt storage
    mkdir -p /crypt-storage

    # Disable all input echo for the whole stage. We could use read -s
    # instead but that would ocasionally leak characters between read
    # invocations.
    stty -echo
  '';

  postCommands = ''
    stty echo
    umount /crypt-storage 2>/dev/null
    umount /crypt-ramfs 2>/dev/null
  '';

  openCommand = name': { name, device, header, keyFile, keyFileSize, keyFileOffset, allowDiscards, yubikey, fallbackToPassword, ... }: assert name' == name;
  let
    csopen   = "cryptsetup luksOpen ${device} ${name} ${optionalString allowDiscards "--allow-discards"} ${optionalString (header != null) "--header=${header}"}";
    cschange = "cryptsetup luksChangeKey ${device} ${optionalString (header != null) "--header=${header}"}";
  in ''
    # Wait for luksRoot (and optionally keyFile and/or header) to appear, e.g.
    # if on a USB drive.
    wait_target "device" ${device} || die "${device} is unavailable"

    ${optionalString (header != null) ''
      wait_target "header" ${header} || die "${header} is unavailable"
    ''}

    do_open_passphrase() {
        local passphrase

        while true; do
            echo -n "Passphrase for ${device}: "
            passphrase=
            while true; do
                if [ -e /crypt-ramfs/passphrase ]; then
                    echo "reused"
                    passphrase=$(cat /crypt-ramfs/passphrase)
                    break
                else
                    # ask cryptsetup-askpass
                    echo -n "${device}" > /crypt-ramfs/device

                    # and try reading it from /dev/console with a timeout
                    IFS= read -t 1 -r passphrase
                    if [ -n "$passphrase" ]; then
                       ${if luks.reusePassphrases then ''
                         # remember it for the next device
                         echo -n "$passphrase" > /crypt-ramfs/passphrase
                       '' else ''
                         # Don't save it to ramfs. We are very paranoid
                       ''}
                       echo
                       break
                    fi
                fi
            done
            echo -n "Verifiying passphrase for ${device}..."
            echo -n "$passphrase" | ${csopen} --key-file=-
            if [ $? == 0 ]; then
                echo " - success"
                ${if luks.reusePassphrases then ''
                  # we don't rm here because we might reuse it for the next device
                '' else ''
                  rm -f /crypt-ramfs/passphrase
                ''}
                break
            else
                echo " - failure"
                # ask for a different one
                rm -f /crypt-ramfs/passphrase
            fi
        done
    }

    # LUKS
    open_normally() {
        ${if (keyFile != null) then ''
        if wait_target "key file" ${keyFile}; then
            ${csopen} --key-file=${keyFile} \
              ${optionalString (keyFileSize != null) "--keyfile-size=${toString keyFileSize}"} \
              ${optionalString (keyFileOffset != null) "--keyfile-offset=${toString keyFileOffset}"}
        else
            ${if fallbackToPassword then "echo" else "die"} "${keyFile} is unavailable"
            echo " - failing back to interactive password prompt"
            do_open_passphrase
        fi
        '' else ''
        do_open_passphrase
        ''}
    }

    ${if luks.yubikeySupport && (yubikey != null) then ''
    # Yubikey
    rbtohex() {
        ( od -An -vtx1 | tr -d ' \n' )
    }

    hextorb() {
        ( tr '[:lower:]' '[:upper:]' | sed -e 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/gI' | xargs printf )
    }

    do_open_yubikey() {
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

        mount -t ${yubikey.storage.fsType} ${yubikey.storage.device} /crypt-storage || \
          die "Failed to mount Yubikey salt storage device"

        salt="$(cat /crypt-storage${yubikey.storage.path} | sed -n 1p | tr -d '\n')"
        iterations="$(cat /crypt-storage${yubikey.storage.path} | sed -n 2p | tr -d '\n')"
        challenge="$(echo -n $salt | openssl-wrap dgst -binary -sha512 | rbtohex)"
        response="$(ykchalresp -${toString yubikey.slot} -x $challenge 2>/dev/null)"

        for try in $(seq 3); do
            ${optionalString yubikey.twoFactor ''
            echo -n "Enter two-factor passphrase: "
            read -r k_user
            echo
            ''}

            if [ ! -z "$k_user" ]; then
                k_luks="$(echo -n $k_user | pbkdf2-sha512 ${toString yubikey.keyLength} $iterations $response | rbtohex)"
            else
                k_luks="$(echo | pbkdf2-sha512 ${toString yubikey.keyLength} $iterations $response | rbtohex)"
            fi

            echo -n "$k_luks" | hextorb | ${csopen} --key-file=-

            if [ $? == 0 ]; then
                opened=true
                break
            else
                opened=false
                echo "Authentication failed!"
            fi
        done

        [ "$opened" == false ] && die "Maximum authentication errors reached"

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

        echo -n "$new_k_luks" | hextorb > /crypt-ramfs/new_key
        echo -n "$k_luks" | hextorb | ${cschange} --key-file=- /crypt-ramfs/new_key

        if [ $? == 0 ]; then
            echo -ne "$new_salt\n$new_iterations" > /crypt-storage${yubikey.storage.path}
        else
            echo "Warning: Could not update LUKS key, current challenge persists!"
        fi

        rm -f /crypt-ramfs/new_key
        umount /crypt-storage
    }

    open_yubikey() {
        if wait_yubikey ${toString yubikey.gracePeriod}; then
            do_open_yubikey
        else
            echo "No yubikey found, falling back to non-yubikey open procedure"
            open_normally
        fi
    }

    open_yubikey
    '' else ''
    open_normally
    ''}
  '';

  askPass = pkgs.writeScriptBin "cryptsetup-askpass" ''
    #!/bin/sh

    ${commonFunctions}

    while true; do
        wait_target "luks" /crypt-ramfs/device 10 "LUKS to request a passphrase" || die "Passphrase is not requested now"
        device=$(cat /crypt-ramfs/device)

        echo -n "Passphrase for $device: "
        IFS= read -rs passphrase
        echo

        rm /crypt-ramfs/device
        echo -n "$passphrase" > /crypt-ramfs/passphrase
    done
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

          (if pkgs.stdenv.hostPlatform.system == "x86_64-linux" then "aes_x86_64" else "aes_i586")
        ];
      description = ''
        A list of cryptographic kernel modules needed to decrypt the root device(s).
        The default includes all common modules.
      '';
    };

    boot.initrd.luks.forceLuksSupportInInitrd = mkOption {
      type = types.bool;
      default = false;
      internal = true;
      description = ''
        Whether to configure luks support in the initrd, when no luks
        devices are configured.
      '';
    };

    boot.initrd.luks.reusePassphrases = mkOption {
      type = types.bool;
      default = true;
      description = ''
        When opening a new LUKS device try reusing last successful
        passphrase.

        Useful for mounting a number of devices that use the same
        passphrase without retyping it several times.

        Such setup can be useful if you use <command>cryptsetup
        luksSuspend</command>. Different LUKS devices will still have
        different master keys even when using the same passphrase.
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

          keyFileOffset = mkOption {
            default = null;
            example = 4096;
            type = types.nullOr types.int;
            description = ''
              The offset of the key file. Use this in combination with
              <literal>keyFileSize</literal> to use part of a file as key file
              (often the case if a raw device or partition is used as a key file).
              If not specified, the key begins at the first byte of
              <literal>keyFile</literal>.
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

          fallbackToPassword = mkOption {
            default = false;
            type = types.bool;
            description = ''
              Whether to fallback to interactive passphrase prompt if the keyfile
              cannot be found. This will prevent unattended boot should the keyfile
              go missing.
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
                  default = 10;
                  type = types.int;
                  description = "Time in seconds to wait for the Yubikey.";
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
        };
      }));
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

  config = mkIf (luks.devices != {} || luks.forceLuksSupportInInitrd) {

    # actually, sbp2 driver is the one enabling the DMA attack, but this needs to be tested
    boot.blacklistedKernelModules = optionals luks.mitigateDMAAttacks
      ["firewire_ohci" "firewire_core" "firewire_sbp2"];

    # Some modules that may be needed for mounting anything ciphered
    boot.initrd.availableKernelModules = [ "dm_mod" "dm_crypt" "cryptd" "input_leds" ]
      ++ luks.cryptoModules
      # workaround until https://marc.info/?l=linux-crypto-vger&m=148783562211457&w=4 is merged
      # remove once 'modprobe --show-depends xts' shows ecb as a dependency
      ++ (if builtins.elem "xts" luks.cryptoModules then ["ecb"] else []);

    # copy the cryptsetup binary and it's dependencies
    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs ${pkgs.cryptsetup}/bin/cryptsetup
      copy_bin_and_libs ${askPass}/bin/cryptsetup-askpass
      sed -i s,/bin/sh,$out/bin/sh, $out/bin/cryptsetup-askpass

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

    boot.initrd.preFailCommands = postCommands;
    boot.initrd.preLVMCommands = commonFunctions + preCommands + concatStrings (mapAttrsToList openCommand preLVM) + postCommands;
    boot.initrd.postDeviceCommands = commonFunctions + preCommands + concatStrings (mapAttrsToList openCommand postLVM) + postCommands;

    environment.systemPackages = [ pkgs.cryptsetup ];
  };
}
