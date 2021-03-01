{ lib, stdenv, fetchurl, pkg-config
, libsndfile, libpulseaudio
}:

let
  version = "5.8.2";
in stdenv.mkDerivation rec {
  pname = "ekho";
  inherit version;

  meta = with lib; {
    description = "Chinese text-to-speech software";
    homepage    = "http://www.eguidedog.net/ekho.php";
    longDescription = ''
      Ekho (余音) is a free, open source and multilingual text-to-speech (TTS)
      software. It supports Cantonese (Chinese dialect spoken in Hong Kong and
      part of Guangdong province), Mandarin (standard Chinese), Zhaoan Hakka
      (a dialect in Taiwan), Tibetan, Ngangien (an ancient Chinese before
      Yuan Dynasty) and Korean (in trial).
    '';
    license        = licenses.gpl2Plus;
    platforms      = platforms.linux;
    hydraPlatforms = [];
  };

  src = fetchurl {
    url = "mirror://sourceforge/e-guidedog/Ekho/${version}/${pname}-${version}.tar.xz";
    sha256 = "0ym6lpcpsvwvsiwlzkl1509a2hljwcw7synngrmqjq1n49ww00nj";
  };

  preConfigure = with lib; ''
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE ${optionalString stdenv.is64bit "-D_x86_64"}"
    NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -DEKHO_DATA_PATH=\"$out/share/ekho-data\""
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libsndfile libpulseaudio ];
}
