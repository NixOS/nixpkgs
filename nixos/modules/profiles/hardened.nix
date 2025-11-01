# This profile included most standard hardening options enabled by default,
# which may have impacted system stability, feature availability, and performance.
# It was deprecated as of April 2025. For further details, refer to pull request #383438.

{ lib }:
{
  warnings = lib.optional (lib.oldestSupportedReleaseIsAtLeast 2411) ''
    This profile has been deprecated, see pull request #383438 for details.
  '';
}
