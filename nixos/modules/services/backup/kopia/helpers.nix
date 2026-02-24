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

  # Assert two options are mutually exclusive (both can be null).
  mkMutualExclusionAssertion =
    {
      name,
      optionA,
      optionB,
      valueA,
      valueB,
    }:
    {
      assertion = valueA == null || valueB == null;
      message = "services.kopia.backups.${name}: ${optionA} and ${optionB} are mutually exclusive";
    };

  # Generate a warning when a plain text secret is used instead of a file reference.
  # Returns a list with zero or one warning string.
  mkPlainTextWarning =
    {
      name,
      option,
      value,
      fileOption,
    }:
    lib.optional (value != null)
      "services.kopia.backups.${name}: ${option} is set as plain text and will be world-readable in the Nix store. Consider using ${fileOption} instead.";

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
