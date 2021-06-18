{ callPackage, lv2, fontconfig, libvterm-neovim, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "jit";
  version = "unstable-2021-05-08";
  url = "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-0f67241966626a0a51da6676813de96d6407293c.tar.xz";
  sha256 = "0nr7xnycy15ll0lzix7rbqfz5r9mdynsp7md2f5jzpl9w9fy539i";

  additionalBuildInputs = [ lv2 fontconfig libvterm-neovim ];

  description = "A Just-in-Time C/Rust compiler embedded in an LV2 plugin";
})
