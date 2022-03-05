# Supported systems according to RFC0046's definition.
#
# https://github.com/NixOS/rfcs/blob/master/rfcs/0046-platform-support-tiers.md
{ lib }:
rec {
  # List of systems that are built by Hydra.
  hydra = tier1 ++ tier2 ++ tier3 ++ [
    "aarch64-darwin"
  ];

  tier1 = [
    "x86_64-linux"
  ];

  tier2 = [
    "aarch64-linux"
    "x86_64-darwin"
  ];

  tier3 = [
    "armv6l-linux"
    "armv7l-linux"
    "i686-linux"
    "mipsel-linux"
  ];
}
