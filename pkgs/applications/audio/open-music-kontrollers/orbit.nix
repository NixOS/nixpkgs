{ callPackage, zlib, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "orbit";
  version = "unstable-2021-04-13";
  url = "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-f4aa620fc8d77418856581a6a955192af15b3860.tar.xz";
  sha256 = "0z8d8h2w8fb2zx84n697jvy32dc0vf60jyiyh4gm22prgr2dvgkc";

  additionalBuildInputs = [ zlib ];

  description = "An LV2 time event manipulation plugin bundle";
})
