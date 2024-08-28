{ config, lib, pkgs, utils, ... }:

let
  inherit (lib) mkIf mkOption types;

  randomEncryptionCoerce = enable: { inherit enable; };

  randomEncryptionOpts = { ... }: {

    options = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Encrypt swap device with a random key. This way you won't have a persistent swap device.

          WARNING: Don't try to hibernate when you have at least one swap partition with
          this option enabled! We have no way to set the partition into which hibernation image
          is saved, so if your image ends up on an encrypted one you would lose it!

          WARNING #2: Do not use /dev/disk/by-uuid/… or /dev/disk/by-label/… as your swap device
          when using randomEncryption as the UUIDs and labels will get erased on every boot when
          the partition is encrypted. Best to use /dev/disk/by-partuuid/…
        '';
      };

      cipher = mkOption {
        default = "aes-xts-plain64";
        example = "serpent-xts-plain64";
        type = types.str;
        description = ''
          Use specified cipher for randomEncryption.

          Hint: Run "cryptsetup benchmark" to see which one is fastest on your machine.
        '';
      };

      keySize = mkOption {
        default = null;
        example = "512";
        type = types.nullOr types.int;
        description = ''
          Set the encryption key size for the plain device.

          If not specified, the amount of data to read from `source` will be
          determined by cryptsetup.

          See `cryptsetup-open(8)` for details.
        '';
      };

      sectorSize = mkOption {
        default = null;
        example = "4096";
        type = types.nullOr types.int;
        description = ''
          Set the sector size for the plain encrypted device type.

          If not specified, the default sector size is determined from the
          underlying block device.

          See `cryptsetup-open(8)` for details.
        '';
      };

      source = mkOption {
        default = "/dev/urandom";
        example = "/dev/random";
        type = types.str;
        description = ''
          Define the source of randomness to obtain a random key for encryption.
        '';
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
    };

  };

  swapCfg = {config, options, ...}: {

    options = {

      device = mkOption {
        example = "/dev/sda3";
        type = types.nonEmptyStr;
        description = "Path of the device or swap file.";
      };

      label = mkOption {
        example = "swap";
        type = types.str;
        description = ''
          Label of the device.  Can be used instead of {var}`device`.
        '';
      };

      size = mkOption {
        default = null;
        example = 2048;
        type = types.nullOr types.int;
        description = ''
          If this option is set, ‘device’ is interpreted as the
          path of a swapfile that will be created automatically
          with the indicated size (in megabytes).
        '';
      };

      priority = mkOption {
        default = null;
        example = 2048;
        type = types.nullOr types.int;
        description = ''
          Specify the priority of the swap device. Priority is a value between 0 and 32767.
          Higher numbers indicate higher priority.
          null lets the kernel choose a priority, which will show up as a negative value.
        '';
      };

      randomEncryption = mkOption {
        default = false;
        example = {
          enable = true;
          cipher = "serpent-xts-plain64";
          source = "/dev/random";
        };
        type = types.coercedTo types.bool randomEncryptionCoerce (types.submodule randomEncryptionOpts);
        description = ''
          Encrypt swap device with a random key. This way you won't have a persistent swap device.

          HINT: run "cryptsetup benchmark" to test cipher performance on your machine.

          WARNING: Don't try to hibernate when you have at least one swap partition with
          this option enabled! We have no way to set the partition into which hibernation image
          is saved, so if your image ends up on an encrypted one you would lose it!

          WARNING #2: Do not use /dev/disk/by-uuid/… or /dev/disk/by-label/… as your swap device
          when using randomEncryption as the UUIDs and labels will get erased on every boot when
          the partition is encrypted. Best to use /dev/disk/by-partuuid/…
        '';
      };

      discardPolicy = mkOption {
        default = null;
        example = "once";
        type = types.nullOr (types.enum ["once" "pages" "both" ]);
        description = ''
          Specify the discard policy for the swap device. If "once", then the
          whole swap space is discarded at swapon invocation. If "pages",
          asynchronous discard on freed pages is performed, before returning to
          the available pages pool. With "both", both policies are activated.
          See swapon(8) for more information.
        '';
      };

      options = mkOption {
        default = [ "defaults" ];
        example = [ "nofail" ];
        type = types.listOf types.nonEmptyStr;
        description = ''
          Options used to mount the swap.
        '';
      };

      deviceName = mkOption {
        type = types.str;
        internal = true;
      };

      realDevice = mkOption {
        type = types.path;
        internal = true;
      };

    };

    config = {
      device = mkIf options.label.isDefined
        "/dev/disk/by-label/${config.label}";
      deviceName = lib.replaceStrings ["\\"] [""] (utils.escapeSystemdPath config.device);
      realDevice = if config.randomEncryption.enable then "/dev/mapper/${config.deviceName}" else config.device;
    };

  };

in

{

  ###### interface

  options = {

    swapDevices = mkOption {
      default = [];
      example = [
        { device = "/dev/hda7"; }
        { device = "/var/swapfile"; }
        { label = "bigswap"; }
      ];
      description = ''
        The swap devices and swap files.  These must have been
        initialised using {command}`mkswap`.  Each element
        should be an attribute set specifying either the path of the
        swap device or file (`device`) or the label
        of the swap device (`label`, see
        {command}`mkswap -L`).  Using a label is
        recommended.
      '';

      type = types.listOf (types.submodule swapCfg);
    };

  };

  config = mkIf ((lib.length config.swapDevices) != 0) {
    assertions = lib.map (sw: {
      assertion = sw.randomEncryption.enable -> builtins.match "/dev/disk/by-(uuid|label)/.*" sw.device == null;
      message = ''
        You cannot use swap device "${sw.device}" with randomEncryption enabled.
        The UUIDs and labels will get erased on every boot when the partition is encrypted.
        Use /dev/disk/by-partuuid/… instead.
      '';
    }) config.swapDevices;

    warnings =
      lib.concatMap (sw:
        if sw.size != null && lib.hasPrefix "/dev/" sw.device
        then [ "Setting the swap size of block device ${sw.device} has no effect" ]
        else [ ])
      config.swapDevices;

    system.requiredKernelConfig = [
      (config.lib.kernelConfig.isYes "SWAP")
    ];

    # Create missing swapfiles.
    systemd.services =
      let
        createSwapDevice = sw:
          let realDevice' = utils.escapeSystemdPath sw.realDevice;
          in lib.nameValuePair "mkswap-${sw.deviceName}"
          { description = "Initialisation of swap device ${sw.device}";
            # The mkswap service fails for file-backed swap devices if the
            # loop module has not been loaded before the service runs.
            # We add an ordering constraint to run after systemd-modules-load to
            # avoid this race condition.
            after = [ "systemd-modules-load.service" ];
            wantedBy = [ "${realDevice'}.swap" ];
            before = [ "${realDevice'}.swap" "shutdown.target"];
            conflicts = [ "shutdown.target" ];
            path = [ pkgs.util-linux pkgs.e2fsprogs ]
              ++ lib.optional sw.randomEncryption.enable pkgs.cryptsetup;

            environment.DEVICE = sw.device;

            script =
              ''
                ${lib.optionalString (sw.size != null) ''
                  currentSize=$(( $(stat -c "%s" "$DEVICE" 2>/dev/null || echo 0) / 1024 / 1024 ))
                  if [[ ! -b "$DEVICE" && "${toString sw.size}" != "$currentSize" ]]; then
                    # Disable CoW for CoW based filesystems like BTRFS.
                    truncate --size 0 "$DEVICE"
                    chattr +C "$DEVICE" 2>/dev/null || true

                    echo "Creating swap file using dd and mkswap."
                    dd if=/dev/zero of="$DEVICE" bs=1M count=${toString sw.size} status=progress
                    ${lib.optionalString (!sw.randomEncryption.enable) "mkswap ${sw.realDevice}"}
                  fi
                ''}
                ${lib.optionalString sw.randomEncryption.enable ''
                  cryptsetup plainOpen -c ${sw.randomEncryption.cipher} -d ${sw.randomEncryption.source} \
                  ${lib.concatStringsSep " \\\n" (lib.flatten [
                    (lib.optional (sw.randomEncryption.sectorSize != null) "--sector-size=${toString sw.randomEncryption.sectorSize}")
                    (lib.optional (sw.randomEncryption.keySize != null) "--key-size=${toString sw.randomEncryption.keySize}")
                    (lib.optional sw.randomEncryption.allowDiscards "--allow-discards")
                  ])} ${sw.device} ${sw.deviceName}
                  mkswap ${sw.realDevice}
                ''}
              '';

            unitConfig.RequiresMountsFor = [ "${dirOf sw.device}" ];
            unitConfig.DefaultDependencies = false; # needed to prevent a cycle
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = sw.randomEncryption.enable;
              UMask = "0177";
              ExecStop = lib.optionalString sw.randomEncryption.enable "${pkgs.cryptsetup}/bin/cryptsetup luksClose ${sw.deviceName}";
            };
            restartIfChanged = false;
          };

      in lib.listToAttrs (lib.map createSwapDevice (lib.filter (sw: sw.size != null || sw.randomEncryption.enable) config.swapDevices));

  };

}
