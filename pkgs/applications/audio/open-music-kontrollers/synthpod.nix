{ callPackage, lilv, libjack2, alsaLib, zita-alsa-pcmi, libxcb, xcbutilxrm, sratom, gtk2, gtk3, qt4, qt5,  libvterm-neovim, robodoc, cmake,... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "synthpod";
  version = "unstable-2020-12-04";

  url = "https://git.open-music-kontrollers.ch/lv2/synthpod/snapshot/synthpod-f06b5ad2d875274ff3c7548c5b218fe712c3bbc1.tar.xz";
  sha256 = "0wnjzgrbjf5s06jjd0dpml45mg2dq7pvyfvhxir0bp75kcw3i7vp";

  additionalBuildInputs = [ lilv libjack2 alsaLib zita-alsa-pcmi libxcb xcbutilxrm sratom gtk2 gtk3 qt4 qt5.qtbase qt5.wrapQtAppsHook  libvterm-neovim robodoc cmake ];

  description = "Lightweight Nonlinear LV2 Plugin Container";
})
