# fwupd daemon.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fwupd;
  originalEtc =
    let
      isRegular = v: v == "regular";
      listFiles = d: builtins.attrNames (filterAttrs (const isRegular) (builtins.readDir d));
      copiedDirs = [ "fwupd/remotes.d" "pki/fwupd" "pki/fwupd-metadata" ];
      originalFiles = concatMap (d: map (f: "${d}/${f}") (listFiles "${pkgs.fwupd}/etc/${d}")) copiedDirs;
      mkEtcFile = n: nameValuePair n { source = "${pkgs.fwupd}/etc/${n}"; };
    in listToAttrs (map mkEtcFile originalFiles);
in {

  ###### interface
  options = {
    services.fwupd = {
      enable = mkOption {
        type = types.bool;
        default = true;
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
        default = [];
        example = [ "udev" ];
        description = ''
          Allow blacklisting specific plugins
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
    } // originalEtc;

    services.dbus.packages = [ pkgs.fwupd ];

    services.udev.packages = [ pkgs.fwupd ];

    systemd.packages = [ pkgs.fwupd ];

    systemd.tmpfiles.rules = [
      "d /var/lib/fwupd 0755 root root -"
    ];
  };
}
