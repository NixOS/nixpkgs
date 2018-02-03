{ stdenv, fetchurl, bitwig-studio1,
  xdg_utils, zenity, ffmpeg }:

bitwig-studio1.overrideAttrs (oldAttrs: rec {
  name = "bitwig-studio-${version}";
  version = "2.2.2";

  src = fetchurl {
    url    = "https://downloads.bitwig.com/stable/${version}/bitwig-studio-${version}.deb";
    sha256 = "1x4wka32xlygmhdh9rb15s37zh5qjrgap2qk35y34c52lf5aak22";
  };

  buildInputs = bitwig-studio1.buildInputs ++ [ ffmpeg ];

  binPath = stdenv.lib.makeBinPath [
    ffmpeg xdg_utils zenity
  ];
})
