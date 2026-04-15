# This profile included most standard hardening options enabled by default,
# which may have impacted system stability, feature availability, and performance.

{ lib, ... }:
{
  imports = [
    (lib.mkRemovedOptionModule [ "profiles" "hardened" ] ''
      The hardened profile has been removed, see the backward incompatibilities section of the 26.05 release notes for more information.
    '')
  ];
}
