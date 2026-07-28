{ lib, darwin }:

self: super: {
  passthru = super.passthru or { } // {
    sourceRelease =
      name:
      lib.warn
        "`apple-sdk.sourceRelease` is deprecated and is now an alias for `darwin.sourceRelease`. Please use `darwin.sourceRelease` directly."
        darwin.sourceRelease
        name;
  };
}
