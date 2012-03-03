{pkgs, config, ...}:

with pkgs.lib;

let
  luks = config.boot.initrd.luks;

  openCommand = { name, device }: ''
    # Wait for luksRoot to appear, e.g. if on a usb drive.
    # XXX: copied and adapted from stage-1-init.sh - should be
    # available as a function.
    if ! test -e ${device}; then
        echo -n "waiting 10 seconds for device ${device} to appear..."
        for ((try = 0; try < 10; try++)); do
            sleep 1
            if test -e ${device}; then break; fi
            echo -n "OK"
        done
        echo "ok"
    fi

    # open luksRoot and scan for logical volumes
    cryptsetup luksOpen ${device} ${name}
  '';

in
{

  options = {
    boot.initrd.luks.enable = mkOption {
      default = false;
      description = '';
        Have luks in the initrd.
      '';
    };

    boot.initrd.luks.devices = mkOption {
      default = [ ];
      example = [ { name = "luksroot"; device = "/dev/sda3"; } ];
      description = '';
        The list of devices that should be decrypted using LUKS before trying to mount the
        root partition. This works for both LVM-over-LUKS and LUKS-over-LVM setups.

        The devices are decrypted to the device mapper names defined.

        Make sure that initrd has the crypto modules needed for decryption.
      '';
    };
  };

  config = mkIf luks.enable {

    # Some modules that may be needed for mounting anything ciphered
    boot.initrd.kernelModules = [ "aes_generic" "aes_x86_64" "dm_mod" "dm_crypt"
      "sha256_generic" "cbc" "cryptd" ];

    # copy the cryptsetup binary and it's dependencies
    boot.initrd.extraUtilsCommands = ''
      cp -pdv ${pkgs.cryptsetup}/sbin/cryptsetup $out/bin
      # XXX: do we have a function that does this?
      for lib in $(ldd $out/bin/cryptsetup |grep '=>' |grep /nix/store/ |cut -d' ' -f3); do
        cp -pdvn $lib $out/lib
        cp -pvn $(readlink -f $lib) $out/lib
      done
    '';

    boot.initrd.extraUtilsCommandsTest = ''
      $out/bin/cryptsetup --version
    '';

    boot.initrd.preLVMCommands = concatMapStrings openCommand luks.devices;
  };
}
