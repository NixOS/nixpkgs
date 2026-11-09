{
  config,
  options,
  lib,
  utils,
  pkgs,
  ...
}:

let
  inherit (lib)
    optional
    filterAttrs
    optionals
    mkRemovedOptionModule
    mkOption
    types
    mkIf
    any
    attrValues
    versionAtLeast
    hasAttr
    mkMerge
    mapAttrs'
    nameValuePair
    ;

  luks = config.boot.initrd.luks;
  clevis = config.boot.initrd.clevis;
  kernelPackages = config.boot.kernelPackages;

  stage1Crypttab = pkgs.writeText "initrd-crypttab" (
    lib.concatLines (
      lib.mapAttrsToList (
        n: v:
        let
          opts =
            v.crypttabExtraOpts
            ++ optional v.allowDiscards "discard"
            ++ optionals v.bypassWorkqueues [
              "no-read-workqueue"
              "no-write-workqueue"
            ]
            ++ optional (v.header != null) "header=${v.header}"
            ++ optional (v.keyFileOffset != null) "keyfile-offset=${toString v.keyFileOffset}"
            ++ optional (v.keyFileSize != null) "keyfile-size=${toString v.keyFileSize}"
            ++ optional (v.keyFileTimeout != null) "keyfile-timeout=${toString v.keyFileTimeout}s"
            ++ optional (v.tryEmptyPassphrase) "try-empty-password=true";
        in
        "${n} ${v.device} ${if v.keyFile == null then "-" else v.keyFile} ${lib.concatStringsSep "," opts}"
      ) luks.devices
    )
  );

in
{
  imports = [
    (mkRemovedOptionModule [ "boot" "initrd" "luks" "enable" ] "")
  ]
  ++
    lib.map (o: mkRemovedOptionModule [ "boot" "initrd" "luks" o ] "Scripted stage 1 has been removed.")
      [
        "reusePassphrases"
        "fallbackToPassword"
        "gpgCard"
        "fido2"
        "yubikey"
        "preOpenCommands"
        "postOpenCommands"
        "gpgSupport"
        "yubikeySupport"
        "fido2Support"
      ];

  options = {

    boot.initrd.luks.mitigateDMAAttacks = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Unless enabled, encryption keys can be easily recovered by an attacker with physical
        access to any machine with PCMCIA, ExpressCard, ThunderBolt or FireWire port.
        More information is available at <https://en.wikipedia.org/wiki/DMA_attack>.

        This option blacklists FireWire drivers, but doesn't remove them. You can manually
        load the drivers if you need to use a FireWire device, but don't forget to unload them!
      '';
    };

    boot.initrd.luks.cryptoModules = mkOption {
      type = types.listOf types.str;
      default = [
        "aes"
        "blowfish"
        "twofish"
        "serpent"
        "cbc"
        "xts"
        "lrw"
        "sha1"
        "sha256"
        "sha512"
        "af_alg"
        "algif_skcipher"
        "cryptd"
        "input_leds" # for capslock LED on most keyboards in case decryption requires password
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

    boot.initrd.luks.devices = mkOption {
      default = { };
      example = {
        luksroot.device = "/dev/disk/by-uuid/430e9eff-d852-4f68-aa3b-2fa3599ebe08";
      };
      description = ''
        The encrypted disk that should be opened before the root
        filesystem is mounted. Both LVM-over-LUKS and LUKS-over-LVM
        setups are supported. The unencrypted devices can be accessed as
        {file}`/dev/mapper/«name»`.
      '';

      type =
        with types;
        attrsOf (
          submodule (
            { config, name, ... }:
            {
              options = {

                name = mkOption {
                  visible = false;
                  default = name;
                  example = "luksroot";
                  type = types.str;
                  description = "Name of the unencrypted device in {file}`/dev/mapper`.";
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

                tryEmptyPassphrase = mkOption {
                  default = false;
                  type = types.bool;
                  description = ''
                    If keyFile fails then try an empty passphrase first before
                    prompting for password.
                  '';
                };

                keyFileTimeout = mkOption {
                  default = null;
                  example = 5;
                  type = types.nullOr types.int;
                  description = ''
                    The amount of time in seconds for a keyFile to appear before
                    timing out and trying passwords.
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
                    `keyFile` will be used decryption, instead of just
                    the first `keyFileSize` bytes.
                  '';
                };

                keyFileOffset = mkOption {
                  default = null;
                  example = 4096;
                  type = types.nullOr types.int;
                  description = ''
                    The offset of the key file. Use this in combination with
                    `keyFileSize` to use part of a file as key file
                    (often the case if a raw device or partition is used as a key file).
                    If not specified, the key begins at the first byte of
                    `keyFile`.
                  '';
                };

                preLVM = mkOption {
                  visible = false;
                  apply =
                    x:
                    throw "The option `${
                      lib.showOption [
                        "boot"
                        "initrd"
                        "luks"
                        "devices"
                        name
                        "preLVM"
                      ]
                    }' can no longer be used since it's been removed. Scripted stage 1 has been removed.";
                };

                allowDiscards = mkOption {
                  default = false;
                  type = types.bool;
                  description = ''
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
                  description = ''
                    Whether to bypass dm-crypt's internal read and write workqueues.
                    Enabling this should improve performance on SSDs; see
                    [here](https://wiki.archlinux.org/index.php/Dm-crypt/Specialties#Disable_workqueue_for_increased_solid_state_drive_(SSD)_performance)
                    for more information. Needs Linux 5.9 or later.
                  '';
                };

                crypttabExtraOpts = mkOption {
                  type = with types; listOf singleLineStr;
                  default = [ ];
                  example = [ "_netdev" ];
                  description = ''
                    Extra options to append to the last column of the generated crypttab file.
                  '';
                };

                timeout = mkOption {
                  type = types.nullOr types.ints.positive;
                  default = luks.timeout;
                  defaultText = "{option}`boot.initrd.luks.timeout`";
                  description = ''
                    The amount of time in seconds to wait on the passphrase prompt.
                    If the timeout is reached, the system will power off.
                  '';
                };
              };

              config = mkIf (clevis.enable && (hasAttr name clevis.devices)) {
                keyFile = "/clevis-${name}/decrypted";
              };
            }
          )
        );
    };

    boot.initrd.luks.timeout = mkOption {
      type = types.nullOr types.ints.positive;
      default = null;
      description = ''
        The amount of time in seconds to wait on the passphrase prompt.
        If the timeout is reached, the system will power off.
      '';
    };

  };

  config = mkIf (luks.devices != { } || luks.forceLuksSupportInInitrd) {

    assertions = [
      {
        assertion =
          any (dev: dev.bypassWorkqueues) (attrValues luks.devices)
          -> versionAtLeast kernelPackages.kernel.version "5.9";
        message = "boot.initrd.luks.devices.<name>.bypassWorkqueues is not supported for kernels older than 5.9";
      }
    ]
    ++ lib.mapAttrsToList (
      name: opts:
      let
        opt = opts.configuration.options.preLVM;
      in
      {
        assertion = !opt.isDefined;
        message = ''
          The option definition `${
            lib.showOption [
              "boot"
              "initrd"
              "luks"
              "devices"
              name
              "preLVM"
            ]
          }' in ${lib.showFiles opt.files} no longer has any effect; please remove it.
          Scripted stage 1 has been removed.
        '';
      }
    ) options.boot.initrd.luks.devices.valueMeta.attrs;

    # actually, sbp2 driver is the one enabling the DMA attack, but this needs to be tested
    boot.blacklistedKernelModules = optionals luks.mitigateDMAAttacks [
      "firewire_ohci"
      "firewire_core"
      "firewire_sbp2"
    ];

    # Some modules that may be needed for mounting anything ciphered
    boot.initrd.availableKernelModules = [
      "dm_mod"
      "dm_crypt"
    ]
    ++ luks.cryptoModules
    # workaround until https://marc.info/?l=linux-crypto-vger&m=148783562211457&w=4 is merged
    # remove once 'modprobe --show-depends xts' shows ecb as a dependency
    ++ (optional (builtins.elem "xts" luks.cryptoModules) "ecb");

    boot.initrd.systemd = {
      contents."/etc/crypttab".source = stage1Crypttab;

      extraBin.systemd-cryptsetup = "${config.boot.initrd.systemd.package}/bin/systemd-cryptsetup";

      additionalUpstreamUnits = [
        "cryptsetup-pre.target"
        "cryptsetup.target"
        "remote-cryptsetup.target"
      ];
      storePaths = [
        "${config.boot.initrd.systemd.package}/bin/systemd-cryptsetup"
        "${config.boot.initrd.systemd.package}/lib/systemd/system-generators/systemd-cryptsetup-generator"
      ]
      ++ lib.optionals config.boot.initrd.systemd.tpm2.enable [
        "${config.boot.initrd.systemd.package}/lib/cryptsetup/libcryptsetup-token-systemd-tpm2.so"
      ];

    };
    # We do this because we need the udev rules from the package
    services.lvm.enable = true;
    boot.initrd.services.lvm.enable = true;

    boot.initrd.systemd.services =
      let
        devicesWithClevis = filterAttrs (device: _: (hasAttr device clevis.devices)) luks.devices;
        devicesWithTimeout = filterAttrs (_: dev: dev.timeout != null) luks.devices;
      in
      mkMerge [
        (mkIf clevis.enable (
          mapAttrs' (
            name: _:
            nameValuePair "cryptsetup-clevis-${name}" {
              wantedBy = [ "systemd-cryptsetup@${utils.escapeSystemdPath name}.service" ];
              before = [
                "systemd-cryptsetup@${utils.escapeSystemdPath name}.service"
                "initrd-switch-root.target"
                "shutdown.target"
              ];
              wants = optional clevis.useTang "network-online.target";
              after = [
                "systemd-modules-load.service"
                "tpm2.target"
              ]
              ++ optional clevis.useTang "network-online.target";
              script = ''
                mkdir -p /clevis-${name}
                mount -t ramfs none /clevis-${name}
                umask 277
                clevis decrypt < /etc/clevis/${name}.jwe > /clevis-${name}/decrypted
              '';
              conflicts = [
                "initrd-switch-root.target"
                "shutdown.target"
              ];
              unitConfig.DefaultDependencies = "no";
              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                ExecStop = "${config.boot.initrd.systemd.package.util-linux}/bin/umount /clevis-${name}";
              };
            }
          ) devicesWithClevis
        ))

        (mapAttrs' (
          name: dev:
          nameValuePair "systemd-cryptsetup@${utils.escapeSystemdPath name}" {
            overrideStrategy = "asDropin";
            unitConfig = {
              JobTimeoutSec = dev.timeout;
              JobTimeoutAction = "poweroff";
            };
          }
        ) devicesWithTimeout)
      ];

    environment.systemPackages = [ pkgs.cryptsetup ];
  };
}
