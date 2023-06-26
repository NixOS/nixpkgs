{ config, options, lib, pkgs, ... }:

with lib;

let
  luks = config.boot.initrd.luks;
  kernelPackages = config.boot.kernelPackages;
  defaultPrio = (mkOptionDefault {}).priority;

  commonFunctions = ''
    die() {
        echo "$@" >&2
        exit 1
    }

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

    wait_yubikey() {
        local secs="''${1:-10}"

        ykinfo -v 1>/dev/null 2>&1
        if [ $? != 0 ]; then
            echo -n "Waiting $secs seconds for YubiKey to appear..."
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

    wait_gpgcard() {
        local secs="''${1:-10}"

        gpg --card-status > /dev/null 2> /dev/null
        if [ $? != 0 ]; then
            echo -n "Waiting $secs seconds for GPG Card to appear"
            local success=false
            for try in $(seq $secs); do
                echo -n .
                sleep 1
                gpg --card-status > /dev/null 2> /dev/null
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

    # Cryptsetup locking directory
    mkdir -p /run/cryptsetup

    # For YubiKey salt storage
    mkdir -p /crypt-storage

    ${optionalString luks.gpgSupport ''
    export GPG_TTY=$(tty)
    export GNUPGHOME=/crypt-ramfs/.gnupg

    gpg-agent --daemon --scdaemon-program $out/bin/scdaemon > /dev/null 2> /dev/null
    ''}

    # Disable all input echo for the whole stage. We could use read -s
    # instead but that would occasionally leak characters between read
    # invocations.
    stty -echo
  '';

  postCommands = ''
    stty echo
    umount /crypt-storage 2>/dev/null
    umount /crypt-ramfs 2>/dev/null
  '';

  openCommand = name: dev: assert name == dev.name;
  let
    csopen = "cryptsetup luksOpen ${dev.device} ${dev.name}"
           + optionalString dev.allowDiscards " --allow-discards"
           + optionalString dev.bypassWorkqueues " --perf-no_read_workqueue --perf-no_write_workqueue"
           + optionalString (dev.header != null) " --header=${dev.header}";
    cschange = "cryptsetup luksChangeKey ${dev.device} ${optionalString (dev.header != null) "--header=${dev.header}"}";
    fido2luksCredentials = dev.fido2.credentials ++ optional (dev.fido2.credential != null) dev.fido2.credential;
  in ''
    # Wait for luksRoot (and optionally keyFile and/or header) to appear, e.g.
    # if on a USB drive.
    wait_target "device" ${dev.device} || die "${dev.device} is unavailable"

    ${optionalString (dev.header != null) ''
      wait_target "header" ${dev.header} || die "${dev.header} is unavailable"
    ''}

    try_empty_passphrase() {
        ${if dev.tryEmptyPassphrase then ''
             echo "Trying empty passphrase!"
             echo "" | ${csopen}
             cs_status=$?
             if [ $cs_status -eq 0 ]; then
                 return 0
             else
                 return 1
             fi
        '' else "return 1"}
    }


    do_open_passphrase() {
        local passphrase

        while true; do
            echo -n "Passphrase for ${dev.device}: "
            passphrase=
            while true; do
                if [ -e /crypt-ramfs/passphrase ]; then
                    echo "reused"
                    passphrase=$(cat /crypt-ramfs/passphrase)
                    break
                else
                    # ask cryptsetup-askpass
                    echo -n "${dev.device}" > /crypt-ramfs/device

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
            echo -n "Verifying passphrase for ${dev.device}..."
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
        ${if (dev.keyFile != null) then ''
        if wait_target "key file" ${dev.keyFile}; then
            ${csopen} --key-file=${dev.keyFile} \
              ${optionalString (dev.keyFileSize != null) "--keyfile-size=${toString dev.keyFileSize}"} \
              ${optionalString (dev.keyFileOffset != null) "--keyfile-offset=${toString dev.keyFileOffset}"}
            cs_status=$?
            if [ $cs_status -ne 0 ]; then
              echo "Key File ${dev.keyFile} failed!"
              if ! try_empty_passphrase; then
                ${if dev.fallbackToPassword then "echo" else "die"} "${dev.keyFile} is unavailable"
                echo " - failing back to interactive password prompt"
                do_open_passphrase
              fi
            fi
        else
            # If the key file never shows up we should also try the empty passphrase
            if ! try_empty_passphrase; then
               ${if dev.fallbackToPassword then "echo" else "die"} "${dev.keyFile} is unavailable"
               echo " - failing back to interactive password prompt"
               do_open_passphrase
            fi
        fi
        '' else ''
           if ! try_empty_passphrase; then
              do_open_passphrase
           fi
        ''}
    }

    ${optionalString (luks.yubikeySupport && (dev.yubikey != null)) ''
    # YubiKey
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

        mount -t ${dev.yubikey.storage.fsType} ${dev.yubikey.storage.device} /crypt-storage || \
          die "Failed to mount YubiKey salt storage device"

        salt="$(cat /crypt-storage${dev.yubikey.storage.path} | sed -n 1p | tr -d '\n')"
        iterations="$(cat /crypt-storage${dev.yubikey.storage.path} | sed -n 2p | tr -d '\n')"
        challenge="$(echo -n $salt | openssl-wrap dgst -binary -sha512 | rbtohex)"
        response="$(ykchalresp -${toString dev.yubikey.slot} -x $challenge 2>/dev/null)"

        for try in $(seq 3); do
            ${optionalString dev.yubikey.twoFactor ''
            echo -n "Enter two-factor passphrase: "
            k_user=
            while true; do
                if [ -e /crypt-ramfs/passphrase ]; then
                    echo "reused"
                    k_user=$(cat /crypt-ramfs/passphrase)
                    break
                else
                    # Try reading it from /dev/console with a timeout
                    IFS= read -t 1 -r k_user
                    if [ -n "$k_user" ]; then
                       ${if luks.reusePassphrases then ''
                         # Remember it for the next device
                         echo -n "$k_user" > /crypt-ramfs/passphrase
                       '' else ''
                         # Don't save it to ramfs. We are very paranoid
                       ''}
                       echo
                       break
                    fi
                fi
            done
            ''}

            if [ ! -z "$k_user" ]; then
                k_luks="$(echo -n $k_user | pbkdf2-sha512 ${toString dev.yubikey.keyLength} $iterations $response | rbtohex)"
            else
                k_luks="$(echo | pbkdf2-sha512 ${toString dev.yubikey.keyLength} $iterations $response | rbtohex)"
            fi

            echo -n "$k_luks" | hextorb | ${csopen} --key-file=-

            if [ $? == 0 ]; then
                opened=true
                ${if luks.reusePassphrases then ''
                  # We don't rm here because we might reuse it for the next device
                '' else ''
                  rm -f /crypt-ramfs/passphrase
                ''}
                break
            else
                opened=false
                echo "Authentication failed!"
            fi
        done

        [ "$opened" == false ] && die "Maximum authentication errors reached"

        echo -n "Gathering entropy for new salt (please enter random keys to generate entropy if this blocks for long)..."
        for i in $(seq ${toString dev.yubikey.saltLength}); do
            byte="$(dd if=/dev/random bs=1 count=1 2>/dev/null | rbtohex)";
            new_salt="$new_salt$byte";
            echo -n .
        done;
        echo "ok"

        new_iterations="$iterations"
        ${optionalString (dev.yubikey.iterationStep > 0) ''
        new_iterations="$(($new_iterations + ${toString dev.yubikey.iterationStep}))"
        ''}

        new_challenge="$(echo -n $new_salt | openssl-wrap dgst -binary -sha512 | rbtohex)"

        new_response="$(ykchalresp -${toString dev.yubikey.slot} -x $new_challenge 2>/dev/null)"

        if [ ! -z "$k_user" ]; then
            new_k_luks="$(echo -n $k_user | pbkdf2-sha512 ${toString dev.yubikey.keyLength} $new_iterations $new_response | rbtohex)"
        else
            new_k_luks="$(echo | pbkdf2-sha512 ${toString dev.yubikey.keyLength} $new_iterations $new_response | rbtohex)"
        fi

        echo -n "$new_k_luks" | hextorb > /crypt-ramfs/new_key
        echo -n "$k_luks" | hextorb | ${cschange} --key-file=- /crypt-ramfs/new_key

        if [ $? == 0 ]; then
            echo -ne "$new_salt\n$new_iterations" > /crypt-storage${dev.yubikey.storage.path}
            sync /crypt-storage${dev.yubikey.storage.path}
        else
            echo "Warning: Could not update LUKS key, current challenge persists!"
        fi

        rm -f /crypt-ramfs/new_key
        umount /crypt-storage
    }

    open_with_hardware() {
        if wait_yubikey ${toString dev.yubikey.gracePeriod}; then
            do_open_yubikey
        else
            echo "No YubiKey found, falling back to non-YubiKey open procedure"
            open_normally
        fi
    }
    ''}

    ${optionalString (luks.gpgSupport && (dev.gpgCard != null)) ''

    do_open_gpg_card() {
        # Make all of these local to this function
        # to prevent their values being leaked
        local pin
        local opened

        gpg --import /gpg-keys/${dev.device}/pubkey.asc > /dev/null 2> /dev/null

        gpg --card-status > /dev/null 2> /dev/null

        for try in $(seq 3); do
            echo -n "PIN for GPG Card associated with device ${dev.device}: "
            pin=
            while true; do
                if [ -e /crypt-ramfs/passphrase ]; then
                    echo "reused"
                    pin=$(cat /crypt-ramfs/passphrase)
                    break
                else
                    # and try reading it from /dev/console with a timeout
                    IFS= read -t 1 -r pin
                    if [ -n "$pin" ]; then
                       ${if luks.reusePassphrases then ''
                         # remember it for the next device
                         echo -n "$pin" > /crypt-ramfs/passphrase
                       '' else ''
                         # Don't save it to ramfs. We are very paranoid
                       ''}
                       echo
                       break
                    fi
                fi
            done
            echo -n "Verifying passphrase for ${dev.device}..."
            echo -n "$pin" | gpg -q --batch --passphrase-fd 0 --pinentry-mode loopback -d /gpg-keys/${dev.device}/cryptkey.gpg 2> /dev/null | ${csopen} --key-file=- > /dev/null 2> /dev/null
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

        [ "$opened" == false ] && die "Maximum authentication errors reached"
    }

    open_with_hardware() {
        if wait_gpgcard ${toString dev.gpgCard.gracePeriod}; then
            do_open_gpg_card
        else
            echo "No GPG Card found, falling back to normal open procedure"
            open_normally
        fi
    }
    ''}

    ${optionalString (luks.fido2Support && fido2luksCredentials != []) ''

    open_with_hardware() {
      local passsphrase

        ${if dev.fido2.passwordLess then ''
          export passphrase=""
        '' else ''
          read -rsp "FIDO2 salt for ${dev.device}: " passphrase
          echo
        ''}
        ${optionalString (lib.versionOlder kernelPackages.kernel.version "5.4") ''
          echo "On systems with Linux Kernel < 5.4, it might take a while to initialize the CRNG, you might want to use linuxPackages_latest."
          echo "Please move your mouse to create needed randomness."
        ''}
          echo "Waiting for your FIDO2 device..."
          fido2luks open${optionalString dev.allowDiscards " --allow-discards"} ${dev.device} ${dev.name} "${builtins.concatStringsSep "," fido2luksCredentials}" --await-dev ${toString dev.fido2.gracePeriod} --salt string:$passphrase
        if [ $? -ne 0 ]; then
          echo "No FIDO2 key found, falling back to normal open procedure"
          open_normally
        fi
    }
    ''}

    # commands to run right before we mount our device
    ${dev.preOpenCommands}

    ${if (luks.yubikeySupport && (dev.yubikey != null)) || (luks.gpgSupport && (dev.gpgCard != null)) || (luks.fido2Support && fido2luksCredentials != []) then ''
    open_with_hardware
    '' else ''
    open_normally
    ''}

    # commands to run right after we mounted our device
    ${dev.postOpenCommands}
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


  stage1Crypttab = pkgs.writeText "initrd-crypttab" (lib.concatStringsSep "\n" (lib.mapAttrsToList (n: v: let
    opts = v.crypttabExtraOpts
      ++ optional v.allowDiscards "discard"
      ++ optionals v.bypassWorkqueues [ "no-read-workqueue" "no-write-workqueue" ]
      ++ optional (v.header != null) "header=${v.header}"
      ++ optional (v.keyFileOffset != null) "keyfile-offset=${toString v.keyFileOffset}"
      ++ optional (v.keyFileSize != null) "keyfile-size=${toString v.keyFileSize}"
      ++ optional (v.keyFileTimeout != null) "keyfile-timeout=${builtins.toString v.keyFileTimeout}s"
      ++ optional (v.tryEmptyPassphrase) "try-empty-password=true"
    ;
  in "${n} ${v.device} ${if v.keyFile == null then "-" else v.keyFile} ${lib.concatStringsSep "," opts}") luks.devices));

in
{
  imports = [
    (mkRemovedOptionModule [ "boot" "initrd" "luks" "enable" ] "")
  ];

  options = {

    boot.initrd.luks.mitigateDMAAttacks = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Unless enabled, encryption keys can be easily recovered by an attacker with physical
        access to any machine with PCMCIA, ExpressCard, ThunderBolt or FireWire port.
        More information is available at <http://en.wikipedia.org/wiki/DMA_attack>.

        This option blacklists FireWire drivers, but doesn't remove them. You can manually
        load the drivers if you need to use a FireWire device, but don't forget to unload them!
      '';
    };

    boot.initrd.luks.cryptoModules = mkOption {
      type = types.listOf types.str;
      default =
        [ "aes" "aes_generic" "blowfish" "twofish"
          "serpent" "cbc" "xts" "lrw" "sha1" "sha256" "sha512"
          "af_alg" "algif_skcipher"
        ];
      description = lib.mdDoc ''
        A list of cryptographic kernel modules needed to decrypt the root device(s).
        The default includes all common modules.
      '';
    };

    boot.initrd.luks.forceLuksSupportInInitrd = mkOption {
      type = types.bool;
      default = false;
      internal = true;
      description = lib.mdDoc ''
        Whether to configure luks support in the initrd, when no luks
        devices are configured.
      '';
    };

    boot.initrd.luks.reusePassphrases = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        When opening a new LUKS device try reusing last successful
        passphrase.

        Useful for mounting a number of devices that use the same
        passphrase without retyping it several times.

        Such setup can be useful if you use {command}`cryptsetup luksSuspend`.
        Different LUKS devices will still have
        different master keys even when using the same passphrase.
      '';
    };

    boot.initrd.luks.devices = mkOption {
      default = { };
      example = { luksroot.device = "/dev/disk/by-uuid/430e9eff-d852-4f68-aa3b-2fa3599ebe08"; };
      description = lib.mdDoc ''
        The encrypted disk that should be opened before the root
        filesystem is mounted. Both LVM-over-LUKS and LUKS-over-LVM
        setups are supported. The unencrypted devices can be accessed as
        {file}`/dev/mapper/«name»`.
      '';

      type = with types; attrsOf (submodule (
        { name, ... }: { options = {

          name = mkOption {
            visible = false;
            default = name;
            example = "luksroot";
            type = types.str;
            description = lib.mdDoc "Name of the unencrypted device in {file}`/dev/mapper`.";
          };

          device = mkOption {
            example = "/dev/disk/by-uuid/430e9eff-d852-4f68-aa3b-2fa3599ebe08";
            type = types.str;
            description = lib.mdDoc "Path of the underlying encrypted block device.";
          };

          header = mkOption {
            default = null;
            example = "/root/header.img";
            type = types.nullOr types.str;
            description = lib.mdDoc ''
              The name of the file or block device that
              should be used as header for the encrypted device.
            '';
          };

          keyFile = mkOption {
            default = null;
            example = "/dev/sdb1";
            type = types.nullOr types.str;
            description = lib.mdDoc ''
              The name of the file (can be a raw device or a partition) that
              should be used as the decryption key for the encrypted device. If
              not specified, you will be prompted for a passphrase instead.
            '';
          };

          tryEmptyPassphrase = mkOption {
            default = false;
            type = types.bool;
            description = lib.mdDoc ''
              If keyFile fails then try an empty passphrase first before
              prompting for password.
            '';
          };

          keyFileTimeout = mkOption {
            default = null;
            example = 5;
            type = types.nullOr types.int;
            description = lib.mdDoc ''
              The amount of time in seconds for a keyFile to appear before
              timing out and trying passwords.
            '';
          };

          keyFileSize = mkOption {
            default = null;
            example = 4096;
            type = types.nullOr types.int;
            description = lib.mdDoc ''
              The size of the key file. Use this if only the beginning of the
              key file should be used as a key (often the case if a raw device
              or partition is used as key file). If not specified, the whole
              `keyFile` will be used decryption, instead of just
              the first `keyFileSize` bytes.
            '';
          };

          keyFileOffset = mkOption {
            default = null;
            example = 4096;
            type = types.nullOr types.int;
            description = lib.mdDoc ''
              The offset of the key file. Use this in combination with
              `keyFileSize` to use part of a file as key file
              (often the case if a raw device or partition is used as a key file).
              If not specified, the key begins at the first byte of
              `keyFile`.
            '';
          };

          # FIXME: get rid of this option.
          preLVM = mkOption {
            default = true;
            type = types.bool;
            description = lib.mdDoc "Whether the luksOpen will be attempted before LVM scan or after it.";
          };

          allowDiscards = mkOption {
            default = false;
            type = types.bool;
            description = lib.mdDoc ''
              Whether to allow TRIM requests to the underlying device. This option
              has security implications; please read the LUKS documentation before
              activating it.
              This option is incompatible with authenticated encryption (dm-crypt
              stacked over dm-integrity).
            '';
          };

          bypassWorkqueues = mkOption {
            default = false;
            type = types.bool;
            description = lib.mdDoc ''
              Whether to bypass dm-crypt's internal read and write workqueues.
              Enabling this should improve performance on SSDs; see
              [here](https://wiki.archlinux.org/index.php/Dm-crypt/Specialties#Disable_workqueue_for_increased_solid_state_drive_(SSD)_performance)
              for more information. Needs Linux 5.9 or later.
            '';
          };

          fallbackToPassword = mkOption {
            default = false;
            type = types.bool;
            description = lib.mdDoc ''
              Whether to fallback to interactive passphrase prompt if the keyfile
              cannot be found. This will prevent unattended boot should the keyfile
              go missing.
            '';
          };

          gpgCard = mkOption {
            default = null;
            description = lib.mdDoc ''
              The option to use this LUKS device with a GPG encrypted luks password by the GPG Smartcard.
              If null (the default), GPG-Smartcard will be disabled for this device.
            '';

            type = with types; nullOr (submodule {
              options = {
                gracePeriod = mkOption {
                  default = 10;
                  type = types.int;
                  description = lib.mdDoc "Time in seconds to wait for the GPG Smartcard.";
                };

                encryptedPass = mkOption {
                  type = types.path;
                  description = lib.mdDoc "Path to the GPG encrypted passphrase.";
                };

                publicKey = mkOption {
                  type = types.path;
                  description = lib.mdDoc "Path to the Public Key.";
                };
              };
            });
          };

          fido2 = {
            credential = mkOption {
              default = null;
              example = "f1d00200d8dc783f7fb1e10ace8da27f8312d72692abfca2f7e4960a73f48e82e1f7571f6ebfcee9fb434f9886ccc8fcc52a6614d8d2";
              type = types.nullOr types.str;
              description = lib.mdDoc "The FIDO2 credential ID.";
            };

            credentials = mkOption {
              default = [];
              example = [ "f1d00200d8dc783f7fb1e10ace8da27f8312d72692abfca2f7e4960a73f48e82e1f7571f6ebfcee9fb434f9886ccc8fcc52a6614d8d2" ];
              type = types.listOf types.str;
              description = lib.mdDoc ''
                List of FIDO2 credential IDs.

                Use this if you have multiple FIDO2 keys you want to use for the same luks device.
              '';
            };

            gracePeriod = mkOption {
              default = 10;
              type = types.int;
              description = lib.mdDoc "Time in seconds to wait for the FIDO2 key.";
            };

            passwordLess = mkOption {
              default = false;
              type = types.bool;
              description = lib.mdDoc ''
                Defines whatever to use an empty string as a default salt.

                Enable only when your device is PIN protected, such as [Trezor](https://trezor.io/).
              '';
            };
          };

          yubikey = mkOption {
            default = null;
            description = lib.mdDoc ''
              The options to use for this LUKS device in YubiKey-PBA.
              If null (the default), YubiKey-PBA will be disabled for this device.
            '';

            type = with types; nullOr (submodule {
              options = {
                twoFactor = mkOption {
                  default = true;
                  type = types.bool;
                  description = lib.mdDoc "Whether to use a passphrase and a YubiKey (true), or only a YubiKey (false).";
                };

                slot = mkOption {
                  default = 2;
                  type = types.int;
                  description = lib.mdDoc "Which slot on the YubiKey to challenge.";
                };

                saltLength = mkOption {
                  default = 16;
                  type = types.int;
                  description = lib.mdDoc "Length of the new salt in byte (64 is the effective maximum).";
                };

                keyLength = mkOption {
                  default = 64;
                  type = types.int;
                  description = lib.mdDoc "Length of the LUKS slot key derived with PBKDF2 in byte.";
                };

                iterationStep = mkOption {
                  default = 0;
                  type = types.int;
                  description = lib.mdDoc "How much the iteration count for PBKDF2 is increased at each successful authentication.";
                };

                gracePeriod = mkOption {
                  default = 10;
                  type = types.int;
                  description = lib.mdDoc "Time in seconds to wait for the YubiKey.";
                };

                /* TODO: Add to the documentation of the current module:

                   Options related to the storing the salt.
                */
                storage = {
                  device = mkOption {
                    default = "/dev/sda1";
                    type = types.path;
                    description = lib.mdDoc ''
                      An unencrypted device that will temporarily be mounted in stage-1.
                      Must contain the current salt to create the challenge for this LUKS device.
                    '';
                  };

                  fsType = mkOption {
                    default = "vfat";
                    type = types.str;
                    description = lib.mdDoc "The filesystem of the unencrypted device.";
                  };

                  path = mkOption {
                    default = "/crypt-storage/default";
                    type = types.str;
                    description = lib.mdDoc ''
                      Absolute path of the salt on the unencrypted device with
                      that device's root directory as "/".
                    '';
                  };
                };
              };
            });
          };

          preOpenCommands = mkOption {
            type = types.lines;
            default = "";
            example = ''
              mkdir -p /tmp/persistent
              mount -t zfs rpool/safe/persistent /tmp/persistent
            '';
            description = lib.mdDoc ''
              Commands that should be run right before we try to mount our LUKS device.
              This can be useful, if the keys needed to open the drive is on another partition.
            '';
          };

          postOpenCommands = mkOption {
            type = types.lines;
            default = "";
            example = ''
              umount /tmp/persistent
            '';
            description = lib.mdDoc ''
              Commands that should be run right after we have mounted our LUKS device.
            '';
          };

          crypttabExtraOpts = mkOption {
            type = with types; listOf singleLineStr;
            default = [];
            example = [ "_netdev" ];
            visible = false;
            description = lib.mdDoc ''
              Only used with systemd stage 1.

              Extra options to append to the last column of the generated crypttab file.
            '';
          };
        };
      }));
    };

    boot.initrd.luks.gpgSupport = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc ''
        Enables support for authenticating with a GPG encrypted password.
      '';
    };

    boot.initrd.luks.yubikeySupport = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc ''
            Enables support for authenticating with a YubiKey on LUKS devices.
            See the NixOS wiki for information on how to properly setup a LUKS device
            and a YubiKey to work with this feature.
          '';
    };

    boot.initrd.luks.fido2Support = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc ''
        Enables support for authenticating with FIDO2 devices.
      '';
    };

  };

  config = mkIf (luks.devices != {} || luks.forceLuksSupportInInitrd) {

    assertions =
      [ { assertion = !(luks.gpgSupport && luks.yubikeySupport);
          message = "YubiKey and GPG Card may not be used at the same time.";
        }

        { assertion = !(luks.gpgSupport && luks.fido2Support);
          message = "FIDO2 and GPG Card may not be used at the same time.";
        }

        { assertion = !(luks.fido2Support && luks.yubikeySupport);
          message = "FIDO2 and YubiKey may not be used at the same time.";
        }

        { assertion = any (dev: dev.bypassWorkqueues) (attrValues luks.devices)
                      -> versionAtLeast kernelPackages.kernel.version "5.9";
          message = "boot.initrd.luks.devices.<name>.bypassWorkqueues is not supported for kernels older than 5.9";
        }

        { assertion = !config.boot.initrd.systemd.enable -> all (x: x.keyFileTimeout == null) (attrValues luks.devices);
          message = "boot.initrd.luks.devices.<name>.keyFileTimeout is only supported for systemd initrd";
        }

        { assertion = config.boot.initrd.systemd.enable -> all (dev: !dev.fallbackToPassword) (attrValues luks.devices);
          message = "boot.initrd.luks.devices.<name>.fallbackToPassword is implied by systemd stage 1.";
        }
        { assertion = config.boot.initrd.systemd.enable -> all (dev: dev.preLVM) (attrValues luks.devices);
          message = "boot.initrd.luks.devices.<name>.preLVM is not used by systemd stage 1.";
        }
        { assertion = config.boot.initrd.systemd.enable -> options.boot.initrd.luks.reusePassphrases.highestPrio == defaultPrio;
          message = "boot.initrd.luks.reusePassphrases has no effect with systemd stage 1.";
        }
        { assertion = config.boot.initrd.systemd.enable -> all (dev: dev.preOpenCommands == "" && dev.postOpenCommands == "") (attrValues luks.devices);
          message = "boot.initrd.luks.devices.<name>.preOpenCommands and postOpenCommands is not supported by systemd stage 1. Please bind a service to cryptsetup.target or cryptsetup-pre.target instead.";
        }
        # TODO
        { assertion = config.boot.initrd.systemd.enable -> !luks.gpgSupport;
          message = "systemd stage 1 does not support GPG smartcards yet.";
        }
        { assertion = config.boot.initrd.systemd.enable -> !luks.fido2Support;
          message = ''
            systemd stage 1 does not support configuring FIDO2 unlocking through `boot.initrd.luks.devices.<name>.fido2`.
            Use systemd-cryptenroll(1) to configure FIDO2 support.
          '';
        }
        # TODO
        { assertion = config.boot.initrd.systemd.enable -> !luks.yubikeySupport;
          message = "systemd stage 1 does not support Yubikeys yet.";
        }
      ];

    # actually, sbp2 driver is the one enabling the DMA attack, but this needs to be tested
    boot.blacklistedKernelModules = optionals luks.mitigateDMAAttacks
      ["firewire_ohci" "firewire_core" "firewire_sbp2"];

    # Some modules that may be needed for mounting anything ciphered
    boot.initrd.availableKernelModules = [ "dm_mod" "dm_crypt" "cryptd" "input_leds" ]
      ++ luks.cryptoModules
      # workaround until https://marc.info/?l=linux-crypto-vger&m=148783562211457&w=4 is merged
      # remove once 'modprobe --show-depends xts' shows ecb as a dependency
      ++ (optional (builtins.elem "xts" luks.cryptoModules) "ecb");

    # copy the cryptsetup binary and it's dependencies
    boot.initrd.extraUtilsCommands = let
      pbkdf2-sha512 = pkgs.runCommandCC "pbkdf2-sha512" { buildInputs = [ pkgs.openssl ]; } ''
        mkdir -p "$out/bin"
        cc -O3 -lcrypto ${./pbkdf2-sha512.c} -o "$out/bin/pbkdf2-sha512"
        strip -s "$out/bin/pbkdf2-sha512"
      '';
    in
    mkIf (!config.boot.initrd.systemd.enable) ''
      copy_bin_and_libs ${pkgs.cryptsetup}/bin/cryptsetup
      copy_bin_and_libs ${askPass}/bin/cryptsetup-askpass
      sed -i s,/bin/sh,$out/bin/sh, $out/bin/cryptsetup-askpass

      ${optionalString luks.yubikeySupport ''
        copy_bin_and_libs ${pkgs.yubikey-personalization}/bin/ykchalresp
        copy_bin_and_libs ${pkgs.yubikey-personalization}/bin/ykinfo
        copy_bin_and_libs ${pkgs.openssl.bin}/bin/openssl

        copy_bin_and_libs ${pbkdf2-sha512}/bin/pbkdf2-sha512

        mkdir -p $out/etc/ssl
        cp -pdv ${pkgs.openssl.out}/etc/ssl/openssl.cnf $out/etc/ssl

        cat > $out/bin/openssl-wrap <<EOF
        #!$out/bin/sh
        export OPENSSL_CONF=$out/etc/ssl/openssl.cnf
        $out/bin/openssl "\$@"
        EOF
        chmod +x $out/bin/openssl-wrap
      ''}

      ${optionalString luks.fido2Support ''
        copy_bin_and_libs ${pkgs.fido2luks}/bin/fido2luks
      ''}


      ${optionalString luks.gpgSupport ''
        copy_bin_and_libs ${pkgs.gnupg}/bin/gpg
        copy_bin_and_libs ${pkgs.gnupg}/bin/gpg-agent
        copy_bin_and_libs ${pkgs.gnupg}/libexec/scdaemon

        ${concatMapStringsSep "\n" (x:
          optionalString (x.gpgCard != null)
            ''
              mkdir -p $out/secrets/gpg-keys/${x.device}
              cp -a ${x.gpgCard.encryptedPass} $out/secrets/gpg-keys/${x.device}/cryptkey.gpg
              cp -a ${x.gpgCard.publicKey} $out/secrets/gpg-keys/${x.device}/pubkey.asc
            ''
          ) (attrValues luks.devices)
        }
      ''}
    '';

    boot.initrd.extraUtilsCommandsTest = mkIf (!config.boot.initrd.systemd.enable) ''
      $out/bin/cryptsetup --version
      ${optionalString luks.yubikeySupport ''
        $out/bin/ykchalresp -V
        $out/bin/ykinfo -V
        $out/bin/openssl-wrap version
      ''}
      ${optionalString luks.gpgSupport ''
        $out/bin/gpg --version
        $out/bin/gpg-agent --version
        $out/bin/scdaemon --version
      ''}
      ${optionalString luks.fido2Support ''
        $out/bin/fido2luks --version
      ''}
    '';

    boot.initrd.systemd = {
      contents."/etc/crypttab".source = stage1Crypttab;

      extraBin.systemd-cryptsetup = "${config.boot.initrd.systemd.package}/lib/systemd/systemd-cryptsetup";

      additionalUpstreamUnits = [
        "cryptsetup-pre.target"
        "cryptsetup.target"
        "remote-cryptsetup.target"
      ];
      storePaths = [
        "${config.boot.initrd.systemd.package}/lib/systemd/systemd-cryptsetup"
        "${config.boot.initrd.systemd.package}/lib/systemd/system-generators/systemd-cryptsetup-generator"
      ];

    };
    # We do this because we need the udev rules from the package
    boot.initrd.services.lvm.enable = true;

    boot.initrd.preFailCommands = mkIf (!config.boot.initrd.systemd.enable) postCommands;
    boot.initrd.preLVMCommands = mkIf (!config.boot.initrd.systemd.enable) (commonFunctions + preCommands + concatStrings (mapAttrsToList openCommand preLVM) + postCommands);
    boot.initrd.postDeviceCommands = mkIf (!config.boot.initrd.systemd.enable) (commonFunctions + preCommands + concatStrings (mapAttrsToList openCommand postLVM) + postCommands);

    environment.systemPackages = [ pkgs.cryptsetup ];
  };
}
