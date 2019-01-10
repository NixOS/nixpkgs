{ stdenv, fetchurl, bitwig-studio1,
  xdg_utils, zenity, ffmpeg }:

bitwig-studio1.overrideAttrs (oldAttrs: rec {
  name = "bitwig-studio-${version}";
  version = "2.4.3";

  src = fetchurl {
    url    = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "17754y4ni0zj9vjxl8ldivi33gdb0nk6sdlcmlpskgffrlx8di08";
  };

  buildInputs = bitwig-studio1.buildInputs ++ [ ffmpeg ];

  binPath = stdenv.lib.makeBinPath [
    ffmpeg xdg_utils zenity
  ];
})
