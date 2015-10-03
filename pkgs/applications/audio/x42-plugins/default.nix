{ stdenv, fetchurl, fetchgit, ftgl, freefont_ttf, libjack2, mesa_glu, pkgconfig
, libltc, libsndfile, libsamplerate
, lv2, mesa, gtk2, cairo, pango, fftwFloat, zita-convolver }:

stdenv.mkDerivation rec {
  version = "2015-07-02";
  name = "x42-plugins-${version}";

  src = fetchurl {
    url = "http://gareus.org/misc/x42-plugins/x42-plugins-20150702.tar.xz";
    sha256 = "1mq0grabzbl9xsd53v2qajhr8nngk0d4lx9n0n3nwy95y2gmy6sm";
  };

  buildInputs = [ mesa_glu ftgl freefont_ttf libjack2 libltc libsndfile libsamplerate lv2 mesa gtk2 cairo pango fftwFloat pkgconfig  zita-convolver];

  makeFlags = [ "PREFIX=$(out)" "FONTFILE=${freefont_ttf}/share/fonts/truetype/FreeSansBold.ttf" "LIBZITACONVOLVER=${zita-convolver}/include/zita-convolver.h" ];

  meta = with stdenv.lib;
    { description = "Collection of LV2 plugins by Robin Gareus";
      homepage = https://github.com/x42/x42-plugins;
      maintainers = with maintainers; [ magnetophon ];
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
}
