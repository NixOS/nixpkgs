# Udisks daemon.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.udisks2;
  settingsFormat = pkgs.formats.ini {
    listToValue = lib.concatMapStringsSep "," (lib.generators.mkValueStringDefault { });
  };
  configFiles = lib.mapAttrs (name: value: (settingsFormat.generate name value)) (
    lib.mapAttrs' (name: value: lib.nameValuePair name value) config.services.udisks2.settings
  );
in

{

  ###### interface

  options = {

    services.udisks2 = {

      enable = lib.mkEnableOption "udisks2, a DBus service that allows applications to query and manipulate storage devices";

      package = lib.mkPackageOption pkgs "udisks" { };

      mountOnMedia = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          When enabled, instructs udisks2 to mount removable drives under `/media/` directory, instead of the
          default, ACL-controlled `/run/media/$USER/`. Since `/media/` is not mounted as tmpfs by default, it
          requires cleanup to get rid of stale mountpoints; enabling this option will take care of this at boot.
        '';
      };

      settings = lib.mkOption rec {
        type = lib.types.attrsOf settingsFormat.type;
        apply = lib.recursiveUpdate default;
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
        example = lib.literalExpression ''
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

  config = lib.mkIf config.services.udisks2.enable {

    environment.systemPackages = [ cfg.package ];

    environment.etc =
      (lib.mapAttrs' (name: value: lib.nameValuePair "udisks2/${name}" { source = value; }) configFiles)
      // (
        let
          libblockdev = cfg.package.libblockdev;
          majorVer = lib.versions.major libblockdev.version;
        in
        {
          # We need to make sure /etc/libblockdev/@major_ver@/conf.d is populated to avoid
          # warnings
          "libblockdev/${majorVer}/conf.d/00-default.cfg".source =
            "${libblockdev}/etc/libblockdev/${majorVer}/conf.d/00-default.cfg";
          "libblockdev/${majorVer}/conf.d/10-lvm-dbus.cfg".source =
            "${libblockdev}/etc/libblockdev/${majorVer}/conf.d/10-lvm-dbus.cfg";
        }
      );

    security.polkit.enable = true;

    services.dbus.packages = [ cfg.package ];

    systemd.tmpfiles.rules = [
      "d /var/lib/udisks2 0755 root root -"
    ]
    ++ lib.optional cfg.mountOnMedia "D! /media 0755 root root -";

    services.udev.packages = [ cfg.package ];

    services.udev.extraRules = lib.optionalString cfg.mountOnMedia ''
      ENV{ID_FS_USAGE}=="filesystem", ENV{UDISKS_FILESYSTEM_SHARED}="1"
    '';

    systemd.packages = [ cfg.package ];
  };

}
