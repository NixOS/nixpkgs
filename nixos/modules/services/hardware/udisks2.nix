# Udisks daemon.
{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.udisks2;
  settingsFormat = pkgs.formats.ini {
    listToValue = concatMapStringsSep "," (generators.mkValueStringDefault {});
  };
  configFiles = mapAttrs (name: value: (settingsFormat.generate name value)) (mapAttrs' (name: value: nameValuePair name value ) config.services.udisks2.settings);
in

{

  ###### interface

  options = {

    services.udisks2 = {

      enable = mkEnableOption "udisks2, a DBus service that allows applications to query and manipulate storage devices";

      mountOnMedia = mkOption {
        type = types.bool;
        default = false;
        description = ''
          When enabled, instructs udisks2 to mount removable drives under `/media/` directory, instead of the
          default, ACL-controlled `/run/media/$USER/`. Since `/media/` is not mounted as tmpfs by default, it
          requires cleanup to get rid of stale mountpoints; enabling this option will take care of this at boot.
        '';
      };

      settings = mkOption rec {
        type = types.attrsOf settingsFormat.type;
        apply = recursiveUpdate default;
        default = {
          "udisks2.conf" = {
            udisks2 = {
              modules = [ "*" ];
              modules_load_preference = "ondemand";
            };
            defaults = {
              encryption = "luks2";
            };
          };
        };
        example = literalExpression ''
        {
          "WDC-WD10EZEX-60M2NA0-WD-WCC3F3SJ0698.conf" = {
            ATA = {
              StandbyTimeout = 50;
            };
          };
        };
        '';
        description = ''
          Options passed to udisksd.
          See [here](http://manpages.ubuntu.com/manpages/latest/en/man5/udisks2.conf.5.html) and
          drive configuration in [here](http://manpages.ubuntu.com/manpages/latest/en/man8/udisks.8.html) for supported options.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.udisks2.enable {

    environment.systemPackages = [ pkgs.udisks2 ];

    environment.etc = (mapAttrs' (name: value: nameValuePair "udisks2/${name}" { source = value; } ) configFiles) // (
    let
      libblockdev = pkgs.udisks2.libblockdev;
      majorVer = versions.major libblockdev.version;
    in {
      # We need to make sure /etc/libblockdev/@major_ver@/conf.d is populated to avoid
      # warnings
      "libblockdev/${majorVer}/conf.d/00-default.cfg".source = "${libblockdev}/etc/libblockdev/${majorVer}/conf.d/00-default.cfg";
      "libblockdev/${majorVer}/conf.d/10-lvm-dbus.cfg".source = "${libblockdev}/etc/libblockdev/${majorVer}/conf.d/10-lvm-dbus.cfg";
    });

    security.polkit.enable = true;

    services.dbus.packages = [ pkgs.udisks2 ];

    systemd.tmpfiles.rules = [ "d /var/lib/udisks2 0755 root root -" ]
      ++ optional cfg.mountOnMedia "D! /media 0755 root root -";

    services.udev.packages = [ pkgs.udisks2 ];

    services.udev.extraRules = optionalString cfg.mountOnMedia ''
      ENV{ID_FS_USAGE}=="filesystem", ENV{UDISKS_FILESYSTEM_SHARED}="1"
    '';

    systemd.packages = [ pkgs.udisks2 ];
  };

}
