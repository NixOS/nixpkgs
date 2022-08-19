# fwupd daemon.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fwupd;

  customEtc = {
    "fwupd/daemon.conf" = {
      source = pkgs.writeText "daemon.conf" ''
        [fwupd]
        DisabledDevices=${lib.concatStringsSep ";" cfg.disabledDevices}
        DisabledPlugins=${lib.concatStringsSep ";" cfg.disabledPlugins}
      '';
    };
    "fwupd/uefi_capsule.conf" = {
      source = pkgs.writeText "uefi_capsule.conf" ''
        [uefi_capsule]
        OverrideESPMountPoint=${config.boot.loader.efi.efiSysMountPoint}
      '';
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

  # We cannot include the file in $out and rely on filesInstalledToEtc
  # to install it because it would create a cyclic dependency between
  # the outputs. We also need to enable the remote,
  # which should not be done by default.
  testRemote = if cfg.enableTestRemote then {
    "fwupd/remotes.d/fwupd-tests.conf" = {
      source = pkgs.runCommand "fwupd-tests-enabled.conf" {} ''
        sed "s,^Enabled=false,Enabled=true," \
        "${cfg.package.installedTests}/etc/fwupd/remotes.d/fwupd-tests.conf" > "$out"
      '';
    };
  } else {};
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

      disabledDevices = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "2082b5e0-7a64-478a-b1b2-e3404fab6dad" ];
        description = lib.mdDoc ''
          Allow disabling specific devices by their GUID
        '';
      };

      disabledPlugins = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "udev" ];
        description = lib.mdDoc ''
          Allow disabling specific plugins
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
    };
  };

  imports = [
    (mkRenamedOptionModule [ "services" "fwupd" "blacklistDevices"] [ "services" "fwupd" "disabledDevices" ])
    (mkRenamedOptionModule [ "services" "fwupd" "blacklistPlugins"] [ "services" "fwupd" "disabledPlugins" ])
  ];

  ###### implementation
  config = mkIf cfg.enable {
    # Disable test related plug-ins implicitly so that users do not have to care about them.
    services.fwupd.disabledPlugins = cfg.package.defaultDisabledPlugins;

    environment.systemPackages = [ cfg.package ];

    # customEtc overrides some files from the package
    environment.etc = originalEtc // customEtc // extraTrustedKeys // testRemote;

    services.dbus.packages = [ cfg.package ];

    services.udev.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];
  };

  meta = {
    maintainers = pkgs.fwupd.meta.maintainers;
  };
}
