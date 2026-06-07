{ callPackage, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    pname = "router";
    version = "unstable-2021-04-13";

    url = "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-7d754dd64c540d40b828166401617715dc235ca3.tar.xz";
    sha256 = "sha256-LjaW5Xdxfjzd6IJ2ptHzmHt7fhU1HQo7ubZ4USVqRE8=";

    description = "Atom/Audio/CV router LV2 plugin bundle";
  }
)
