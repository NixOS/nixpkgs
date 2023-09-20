{ callPackage, faust, fontconfig, cmake, libvterm-neovim, libevdev, libglvnd, fira-code, ... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "mephisto";
  version = "0.16.0";

  sha256 = "0vgr3rsvdj4w0xpc5iqpvyqilk42wr9zs8bg26sfv3f2wi4hb6gx";

  additionalBuildInputs = [ faust fontconfig cmake libvterm-neovim libevdev libglvnd fira-code ];

  # see: https://github.com/OpenMusicKontrollers/mephisto.lv2/issues/6
  postPatch = ''
    sed -i 's/llvm-c-dsp/llvm-dsp-c/g' mephisto.c
  '';

  description = "A Just-in-time FAUST embedded in an LV2 plugin";
})
