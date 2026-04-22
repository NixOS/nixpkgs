{ lib }:
{
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
