# fwupd daemon.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fwupd;
  originalEtc =
    let
      mkEtcFile = n: nameValuePair n { source = "${pkgs.fwupd}/etc/${n}"; };
    in listToAttrs (map mkEtcFile pkgs.fwupd.filesInstalledToEtc);
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
        "${pkgs.fwupd.installedTests}/etc/fwupd/remotes.d/fwupd-tests.conf" > "$out"
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
        description = ''
          Whether to enable fwupd, a DBus service that allows
          applications to update firmware.
        '';
      };

      blacklistDevices = mkOption {
        type = types.listOf types.string;
        default = [];
        example = [ "2082b5e0-7a64-478a-b1b2-e3404fab6dad" ];
        description = ''
          Allow blacklisting specific devices by their GUID
        '';
      };

      blacklistPlugins = mkOption {
        type = types.listOf types.string;
        default = [ "test" ];
        example = [ "udev" ];
        description = ''
          Allow blacklisting specific plugins
        '';
      };

      extraTrustedKeys = mkOption {
        type = types.listOf types.path;
        default = [];
        example = literalExample "[ /etc/nixos/fwupd/myfirmware.pem ]";
        description = ''
          Installing a public key allows firmware signed with a matching private key to be recognized as trusted, which may require less authentication to install than for untrusted files. By default trusted firmware can be upgraded (but not downgraded) without the user or administrator password. Only very few keys are installed by default.
        '';
      };

      enableTestRemote = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable test remote. This is used by
          <link xlink:href="https://github.com/hughsie/fwupd/blob/master/data/installed-tests/README.md">installed tests</link>.
        '';
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.fwupd ];

    environment.etc = {
      "fwupd/daemon.conf" = {
        source = pkgs.writeText "daemon.conf" ''
          [fwupd]
          BlacklistDevices=${lib.concatStringsSep ";" cfg.blacklistDevices}
          BlacklistPlugins=${lib.concatStringsSep ";" cfg.blacklistPlugins}
        '';
      };
      "fwupd/uefi.conf" = {
        source = pkgs.writeText "uefi.conf" ''
          [uefi]
          OverrideESPMountPoint=${config.boot.loader.efi.efiSysMountPoint}
        '';
      };

    } // originalEtc // extraTrustedKeys // testRemote;

    services.dbus.packages = [ pkgs.fwupd ];

    services.udev.packages = [ pkgs.fwupd ];

    systemd.packages = [ pkgs.fwupd ];

    systemd.tmpfiles.rules = [
      "d /var/lib/fwupd 0755 root root -"
    ];
  };

  meta = {
    maintainers = pkgs.fwupd.meta.maintainers;
  };
}
