{ stdenv, fetchurl, bitwig-studio1,
  xdg_utils, zenity, ffmpeg }:

bitwig-studio1.overrideAttrs (oldAttrs: rec {
  name = "bitwig-studio-${version}";
  version = "2.3.2";

  src = fetchurl {
    url    = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "10ji4jqnnlhv4bgvhqwysprax6jcjk4759jskr9imwj6qjnj3vzn";
  };

  buildInputs = bitwig-studio1.buildInputs ++ [ ffmpeg ];

  binPath = stdenv.lib.makeBinPath [
    ffmpeg xdg_utils zenity
  ];
})
