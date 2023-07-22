# See [RFC 46] for mandated platform support and ../../pkgs/stdenv for
# implemented platform support. This list is mainly descriptive, i.e. all
# system doubles for platforms where nixpkgs can do native compilation
# reasonably well are included.
#
# [RFC 46]: https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md
{ lib }:

let
  inherit (builtins) filter;
  inherit (lib.lists) any;
  inherit (lib.systems) elaborate;
  inherit (lib.systems.supported) Tier1 Tier2 Tier3 Tier7;

  anyOf = includes: filter (s: any (include: s == include) includes);
  getDoubles = map (s: (elaborate s).system);
in
getDoubles
  (  Tier1
  ++ Tier2
  )
++ anyOf [ "armv6l-linux"
           "armv7l-linux"
           "i686-linux"
           "mipsel-linux"
         ]
         (getDoubles Tier3)
# Other platforms with sufficient support in stdenv which is not formally
# mandated by their platform tier.
++ anyOf [ "aarch64-darwin"
           "armv5tel-linux"
           "powerpc64-linux"
           "riscv64-linux"
         ]
         (getDoubles Tier7)
