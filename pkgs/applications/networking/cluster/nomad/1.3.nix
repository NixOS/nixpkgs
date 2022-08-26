{ callPackage
, buildGoModule
}:

callPackage ./generic.nix {
  inherit buildGoModule;
  version = "1.3.4";
  sha256 = "sha256-NeBZVCpylP16dPi68unk3H3/V6gWO/SvJRmjgwwwVts=";
  vendorSha256 = "sha256-XIHtAB0js55mbVuTTWdLW5BMhQjd6/GUbcBk8DEYZg8=";
}
