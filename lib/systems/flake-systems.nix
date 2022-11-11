# See [RFC 46] for mandated platform support and ../../pkgs/stdenv for
# implemented platform support. This list is mainly descriptive, i.e. all
# system doubles for platforms where nixpkgs can do native compiliation
# reasonably well are included.
#
# [RFC 46]: https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md
{ }:

[
  # Tier 1
  "x86_64-linux"
  # Tier 2
  "aarch64-linux"
  "x86_64-darwin"
  # Tier 3
  "armv6l-linux"
  "armv7l-linux"
  "i686-linux"
  "mipsel-linux"

  # Other platforms with sufficient support in stdenv which is not formally
  # mandated by their platform tier.
  "aarch64-darwin"
  "armv5tel-linux"
  "powerpc64le-linux"
  "riscv64-linux"

  # "x86_64-freebsd" is excluded because it is mostly broken
]
