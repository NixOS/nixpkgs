{ stdenv, fetchurl, bitwig-studio1,
  xdg_utils, zenity, ffmpeg }:

bitwig-studio1.overrideAttrs (oldAttrs: rec {
  name = "bitwig-studio-${version}";
  version = "2.3.1";

  src = fetchurl {
    url    = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "18gghx0ygwh01cidj8mkf82l9qhq2dy1b3yc4ajksvj762yg6cf2";
  };

  buildInputs = bitwig-studio1.buildInputs ++ [ ffmpeg ];

  binPath = stdenv.lib.makeBinPath [
    ffmpeg xdg_utils zenity
  ];
})
