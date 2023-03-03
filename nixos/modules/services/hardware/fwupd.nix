# fwupd daemon.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fwupd;

  format = pkgs.formats.ini {
    listToValue = l: lib.concatStringsSep ";" (map (s: generators.mkValueStringDefault {} s) l);
    mkKeyValue = generators.mkKeyValueDefault {} "=";
  };

  customEtc = {
    "fwupd/daemon.conf" = {
      source = format.generate "daemon.conf" {
        fwupd = cfg.daemonSettings;
      };
    };
  };

  originalEtc =
    let
      mkEtcFile = n: nameValuePair n { source = "${cfg.package}/etc/${n}"; };
    in listToAttrs (map mkEtcFile cfg.package.filesInstalledToEtc);
  extraTrustedKeys =
    let
      mkName = p: "pki/fwupd/${baseNameOf (toString p)}";
      mkEtcFile = p: nameValuePair (mkName p) { source = p; };
    in listToAttrs (map mkEtcFile cfg.extraTrustedKeys);

  enableRemote = base: remote: {
    "fwupd/remotes.d/${remote}.conf" = {
      source = pkgs.runCommand "${remote}-enabled.conf" {} ''
        sed "s,^Enabled=false,Enabled=true," \
        "${base}/etc/fwupd/remotes.d/${remote}.conf" > "$out"
      '';
    };
  };
  remotes = (foldl'
    (configFiles: remote: configFiles // (enableRemote cfg.package remote))
    {}
    cfg.extraRemotes
  ) // (
    # We cannot include the file in $out and rely on filesInstalledToEtc
    # to install it because it would create a cyclic dependency between
    # the outputs. We also need to enable the remote,
    # which should not be done by default.
    if cfg.enableTestRemote then (enableRemote cfg.package.installedTests "fwupd-tests") else {}
  );

in {

  ###### interface
  options = {
    services.fwupd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable fwupd, a DBus service that allows
          applications to update firmware.
        '';
      };

      extraTrustedKeys = mkOption {
        type = types.listOf types.path;
        default = [];
        example = literalExpression "[ /etc/nixos/fwupd/myfirmware.pem ]";
        description = lib.mdDoc ''
          Installing a public key allows firmware signed with a matching private key to be recognized as trusted, which may require less authentication to install than for untrusted files. By default trusted firmware can be upgraded (but not downgraded) without the user or administrator password. Only very few keys are installed by default.
        '';
      };

      extraRemotes = mkOption {
        type = with types; listOf str;
        default = [];
        example = [ "lvfs-testing" ];
        description = lib.mdDoc ''
          Enables extra remotes in fwupd. See `/etc/fwupd/remotes.d`.
        '';
      };

      enableTestRemote = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable test remote. This is used by
          [installed tests](https://github.com/fwupd/fwupd/blob/master/data/installed-tests/README.md).
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.fwupd;
        defaultText = literalExpression "pkgs.fwupd";
        description = lib.mdDoc ''
          Which fwupd package to use.
        '';
      };

      daemonSettings = mkOption {
        type = types.submodule {
          freeformType = format.type.nestedTypes.elemType;
          options = {
            DisabledDevices = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "2082b5e0-7a64-478a-b1b2-e3404fab6dad" ];
              description = lib.mdDoc ''
                List of device GUIDs to be disabled.
              '';
            };

            DisabledPlugins = mkOption {
              type = types.listOf types.str;
              default = [];
              example = [ "udev" ];
              description = lib.mdDoc ''
                List of plugins to be disabled.
              '';
            };

            EspLocation = mkOption {
              type = types.path;
              default = config.boot.loader.efi.efiSysMountPoint;
              defaultText = lib.literalExpression "config.boot.loader.efi.efiSysMountPoint";
              description = lib.mdDoc ''
                The EFI system partition (ESP) path used if UDisks is not available
                or if this partition is not mounted at /boot/efi, /boot, or /efi
              '';
            };
          };
        };
        default = {};
        description = lib.mdDoc ''
          Configurations for the fwupd daemon.
        '';
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "services" "fwupd" "blacklistDevices"] [ "services" "fwupd" "daemonSettings" "DisabledDevices" ])
    (mkRenamedOptionModule [ "services" "fwupd" "blacklistPlugins"] [ "services" "fwupd" "daemonSettings" "DisabledPlugins" ])
    (mkRenamedOptionModule [ "services" "fwupd" "disabledDevices" ] [ "services" "fwupd" "daemonSettings" "DisabledDevices" ])
    (mkRenamedOptionModule [ "services" "fwupd" "disabledPlugins" ] [ "services" "fwupd" "daemonSettings" "DisabledPlugins" ])
  ];

  ###### implementation
  config = mkIf cfg.enable {
    # Disable test related plug-ins implicitly so that users do not have to care about them.
    services.fwupd.daemonSettings = {
      DisabledPlugins = cfg.package.defaultDisabledPlugins;
      EspLocation = config.boot.loader.efi.efiSysMountPoint;
    };

    environment.systemPackages = [ cfg.package ];

    # customEtc overrides some files from the package
    environment.etc = originalEtc // customEtc // extraTrustedKeys // remotes;

    services.dbus.packages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    # required to update the firmware of disks
    services.udisks2.enable = true;

    systemd.packages = [ cfg.package ];

    security.polkit.enable = true;
  };

  meta = {
    maintainers = pkgs.fwupd.meta.maintainers;
  };
}
