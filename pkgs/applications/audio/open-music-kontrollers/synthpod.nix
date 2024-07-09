{ callPackage, lilv, libjack2, alsa-lib, zita-alsa-pcmi, libxcb, xcbutilxrm, sratom, gtk2, qt5,  libvterm-neovim, robodoc, cmake,... } @ args:

callPackage ./generic.nix (args // rec {
  pname = "synthpod";
  version = "unstable-2021-10-22";

  url = "https://git.open-music-kontrollers.ch/lv2/synthpod/snapshot/synthpod-6f284bdad882037a522c120af92b96d8abf2de60.tar.xz";
  sha256 = "sha256-59WBlOKum5Pcmq2CfFfRHCNEa8uPCoBk0kSjFlIcypw=";

  additionalBuildInputs = [ lilv libjack2 alsa-lib zita-alsa-pcmi libxcb xcbutilxrm sratom gtk2 qt5.qtbase qt5.wrapQtAppsHook libvterm-neovim robodoc cmake ];

  description = "Lightweight Nonlinear LV2 Plugin Container";
})
