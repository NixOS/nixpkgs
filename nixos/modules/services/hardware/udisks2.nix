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

    systemd.tmpfiles.rules = lib.optional cfg.mountOnMedia "D! /media 0755 root root -";

    services.udev.packages = [ cfg.package ];

    services.udev.extraRules = lib.optionalString cfg.mountOnMedia ''
      ENV{ID_FS_USAGE}=="filesystem", ENV{UDISKS_FILESYSTEM_SHARED}="1"
    '';

    systemd.packages = [ cfg.package ];

    systemd.services.udisks2 = {
      after = lib.optionals cfg.mountOnMedia [ "systemd-tmpfiles-setup.service" ];
      requires = lib.optionals cfg.mountOnMedia [ "systemd-tmpfiles-setup.service" ];

      serviceConfig = {
        User = "root";
        Group = "root";

        StateDirectory = "udisks2";
        StateDirectoryMode = "0700";
        RuntimeDirectory = "udisks2";
        RuntimeDirectoryMode = "0755";

        # A lot of the omitted Private*/Protect* settings would imply
        # this to be true, which would have the daemon only mount disks
        # inside its own sandbox and so breaking the main functionality.
        PrivateMounts = false;

        CapabilityBoundingSet = [
          "CAP_SYS_ADMIN" # Needed for mount(2) and umount(2)
        ];
        SystemCallFilter = [
          "@system-service"
          "~@privileged @resources"
          "@chown @mount"
        ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        ProtectClock = true;
        ProtectHostname = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_NETLINK" # Needed to talk to udev
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = "022";
      };
    };
  };

}
