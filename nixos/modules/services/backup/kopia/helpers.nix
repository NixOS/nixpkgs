{ lib }:
{
  # Generate systemd service/unit names for kopia services
  mkUnitBaseName = type: name: "kopia-${type}-${name}";
  mkUnitQualifiedName = type: name: "kopia-${type}-${name}.service";

  mkKopiaEnvironment = name: {
    KOPIA_CONFIG_PATH = "/var/lib/kopia/${name}/repository.config";
  };

  mkBaseServiceConfig = name: backup: {
    Type = "oneshot";
    User = backup.user;
    StateDirectory = "kopia/${name}";
    PrivateTmp = true;
    NoNewPrivileges = true;
    ProtectSystem = "strict";
    ReadWritePaths = [
      "/var/lib/kopia/${name}"
    ]
    ++ lib.optional (backup.repository ? filesystem) backup.repository.filesystem.path;
  };

  hasPolicySet =
    backup:
    let
      ret = backup.policy.retention;
      files = backup.policy.files;
      errors = backup.policy.errorHandling;
    in
    lib.any (v: v != null) [
      ret.keepLatest
      ret.keepHourly
      ret.keepDaily
      ret.keepWeekly
      ret.keepMonthly
      ret.keepAnnual
      files.ignoreCacheDirs
      files.maxFileSize
      files.oneFileSystem
      files.noParentIgnore
      errors.ignoreFileErrors
      errors.ignoreDirectoryErrors
      errors.ignoreUnknownTypes
      backup.policy.compression
      backup.policy.splitter.algorithm
    ]
    || files.ignore != [ ]
    || files.ignoreDotFiles != [ ];
}
