{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.bt-dualboot;

  escapedMountPoint = lib.pipe cfg.mountPoint [
    lib.strings.normalizePath
    (lib.removePrefix "/")
    (lib.removeSuffix "/")
    (builtins.replaceStrings [ "/" ] [ "-" ])
  ];

in
{

  meta.maintainers = [ lib.maintainers.bmrips ];

  options.services.bt-dualboot = {
    enable = lib.mkEnableOption "{command}`bt-dualboot`";
    package = lib.mkPackageOption pkgs "bt-dualboot" { };
    mountPoint = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      example = "/mnt";
      description = ''
        The mount point of the Windows data partition. By default,
        {command}`bt-dualboot` will recognize and use mount Windows partitions
        automatically.
      '';
    };
    registryBackups = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to backup the Windows Registry before modifying it.
        '';
      };
      retentionPeriod = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        example = "4 weeks";
        description = ''
          For how long the registry backups are retained.

          Values have to be formatted according to the 'age' field of {manpage}`tmpfiles.d(5)`.
          Set it to `null` to retain backups forever.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = config.services.hardware.bluetooth.enable;
        message = ''
          services.bt-dualboot: `services.hardware.bluetooth` has to be enabled
          since otherwise, there are no bluetooth pairing keys to be synced.
        '';
      }
    ];

    environment.systemPackages = [ cfg.package ];

    systemd.services.bt-dualboot = {
      description = "Copy bluetooth pairing keys to Windows before shutdown";
      wantedBy = [ "multi-user.target" ];

      # Use `RemainAfterExit` and `ExecStop` to run on shutdown
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop =
          "${pkgs.bt-dualboot}/bin/bt-dualboot --sync-all"
          + (if cfg.registryBackups.enable then " --backup" else " --no-backup")
          + lib.optionalString (cfg.mountPoint != null) " --win ${cfg.mountPoint}";
      };
    }
    // lib.optionalAttrs (cfg.mountPoint != null) {
      requires = [ "${escapedMountPoint}.mount" ];
      after = [ "${escapedMountPoint}.mount" ];
    };

    systemd.tmpfiles.settings.bt-dualboot."/var/backup/bt-dualboot/".e.age =
      let
        backups = cfg.registryBackups;
      in
      lib.mkIf (backups.enable && backups.retentionPeriod != null) backups.retentionPeriod;

  };

}
