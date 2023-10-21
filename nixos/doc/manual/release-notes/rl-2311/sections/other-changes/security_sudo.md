- `security.sudo` now provides two extra options, that do not change the
  module's default behaviour:
  - `defaultOptions` controls the options used for the default rules;
  - `keepTerminfo` controls whether `TERMINFO` and `TERMINFO_DIRS` are preserved
    for `root` and the `wheel` group.
