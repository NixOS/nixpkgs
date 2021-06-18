{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "router";
  version = "unstable-2020-10-12";

  url = "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-7d754dd64c540d40b828166401617715dc235ca3.tar.xz";
  sha256 = "0ks4d8jm2y5np4xhl79m2mz7nywqyg8scxl2x3fkqzkifzjrcdif";

  description = "An atom/audio/CV router LV2 plugin bundle";
})
