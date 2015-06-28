{ stdenv, fetchurl, fetchgit, ftgl, freefont_ttf, libjack2, mesa_glu, pkgconfig
, libltc, libsndfile, libsamplerate
, lv2, mesa, gtk2, cairo, pango, fftwFloat, zita-convolver }:

stdenv.mkDerivation rec {
  version = "2014-11-01";
  name = "x42-plugins-${version}";

  src = fetchurl {
    url = "http://gareus.org/misc/x42-plugins/x42-plugins-20141101.tar.xz";
    sha256 = "0pjdhj58hb4n2053v92l7v7097fjm4xzrl8ks4g1hc7miy98ymdk";
  };

  buildInputs = [ mesa_glu ftgl freefont_ttf libjack2 libltc libsndfile libsamplerate lv2 mesa gtk2 cairo pango fftwFloat pkgconfig  zita-convolver];

  makeFlags = [ "PREFIX=$(out)" "FONTFILE=${freefont_ttf}/share/fonts/truetype/FreeSansBold.ttf" ];

  # remove check for zita-convolver in /usr/
  patchPhase = ''
    sed -i "38,42d" convoLV2/Makefile
  '';

  meta = with stdenv.lib;
    { description = "Collection of LV2 plugins by Robin Gareus";
      homepage = https://github.com/x42/x42-plugins;
      maintainers = with maintainers; [ magnetophon ];
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
}
