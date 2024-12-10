{
  callPackage,
  lv2,
  fontconfig,
  libvterm-neovim,
  ...
}@args:

callPackage ./generic.nix (
  args
  // rec {
    pname = "jit";
    version = "unstable-2021-08-15";
    url = "https://git.open-music-kontrollers.ch/lv2/${pname}.lv2/snapshot/${pname}.lv2-1f5d6935049fc0dd5a4dc257b84b36d2048f2d83.tar.xz";
    sha256 = "sha256-XGICowVb0JgLJpn2h9GtViobYTdmo1LJ7/JFEyVsIqU=";

    additionalBuildInputs = [
      lv2
      fontconfig
      libvterm-neovim
    ];

    description = "A Just-in-Time C/Rust compiler embedded in an LV2 plugin";
  }
)
