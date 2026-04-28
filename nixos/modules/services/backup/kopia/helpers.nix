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
      ret.keep-latest
      ret.keep-hourly
      ret.keep-daily
      ret.keep-weekly
      ret.keep-monthly
      ret.keep-annual
      files.ignore-cache-dirs
      files.max-file-size
      files.one-file-system
      errors.ignore-file-errors
      errors.ignore-dir-errors
      errors.ignore-unknown-types
      backup.policy.compression
      backup.policy.splitter
    ]
    || files.ignore != [ ]
    || files.add-dot-ignore != [ ];
}
