# A profile with most (vanilla) hardening options enabled by default,
# potentially at the cost of stability, features and performance.
#
# This profile enables options that are known to affect system
# stability. If you experience any stability issues when using the
# profile, try disabling it. If you report an issue and use this
# profile, always mention that you do.

{ lib }:
{
  warnings = lib.optional (lib.oldestSupportedReleaseIsAtLeast 2511) ''
    This profile is for compatibility and will be removed in the future.
    If you rely on it, consider migrating to the `security.hardening` module.
  '';

  security.hardening.enable = true;
}
