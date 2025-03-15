{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nextcloudBackup;
  nextcloudCfg = config.services.nextcloud;
  runtimeInputs =
    [
      pkgs.coreutils
      pkgs.rsync
      pkgs.jq
      nextcloudCfg.occ
    ]
    ++ (
      if nextcloudCfg.config.dbtype == "sqlite" then
        [ pkgs.sqlite ]
      else if nextcloudCfg.config.dbtype == "pgsql" then
        [ config.services.postgresql.package ]
      else if nextcloudCfg.config.dbtype == "mysql" then
        [ config.services.mysql.package ]
      else
        throw "Unknown nextcloud database type ${nextcloudCfg.config.dbtype}"
    );
  runtimeEnv = {
    "NEXTCLOUD_VERSION" = nextcloudCfg.package.version;
    "NEXTCLOUD_DBTYPE" = nextcloudCfg.config.dbtype;
    "NEXTCLOUD_DBHOST" =
      if nextcloudCfg.config.dbtype == "mysql" && nextcloudCfg.database.createLocally then
        "localhost"
      else
        nextcloudCfg.config.dbhost;
    "NEXTCLOUD_DBNAME" = nextcloudCfg.config.dbname;
    "NEXTCLOUD_DBUSER" = nextcloudCfg.config.dbuser;
    "NEXTCLOUD_DBPASS_FILE" = lib.optionalString (
      nextcloudCfg.config.dbpassFile != null
    ) nextcloudCfg.config.dbpassFile;
    "NEXTCLOUD_DATADIR" = nextcloudCfg.datadir;
    "NEXTCLOUD_HOME" = nextcloudCfg.home;
    "BACKUP_DIR" = lib.optionalString (cfg.backupDir != null) cfg.backupDir;
  };
  bashOptions = [
    "errtrace"
    "errexit"
    "nounset"
    "pipefail"
  ];
  backupScript = pkgs.writeShellApplication {
    name = "nextcloud-backup";
    inherit runtimeInputs runtimeEnv bashOptions;
    text = builtins.readFile ./backup.sh;
  };
  restoreScript = pkgs.writeShellApplication {
    name = "nextcloud-restore";
    inherit runtimeInputs runtimeEnv bashOptions;
    text = builtins.readFile ./restore.sh;
  };
in
{
  options.services.nextcloudBackup = {
    enable = lib.mkEnableOption "nextcloud-backup";
    backupDir = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = ''
        The directory in which the Nextcloud backup will be stored.
        This can be overridden by passing an argument to the backup script.
      '';
      example = "/var/lib/backups";
    };
    backupScript = lib.mkOption {
      type = lib.types.package;
      default = backupScript;
      defaultText = lib.literalMD "generated script";
      description = ''
        A script that backs up the Nextcloud instance (has to be run as the `nextcloud` user).
        This option can be used to reference the script in the NixOS configuration and should usually not be changed.
      '';
    };
    restoreScript = lib.mkOption {
      type = lib.types.package;
      default = restoreScript;
      defaultText = lib.literalMD "generated script";
      description = ''
        A script that restores the Nextcloud instance from a given backup (has to be run as root).
        This option can be used to reference the script in the NixOS configuration and should usually not be changed.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.backupScript
      cfg.restoreScript
    ];
  };
}
