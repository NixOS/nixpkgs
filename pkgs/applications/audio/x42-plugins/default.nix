{ stdenv, fetchurl, fetchgit, ftgl, freefont_ttf, libjack2, mesa_glu, pkgconfig
, libltc, libsndfile, libsamplerate, xz
, lv2, mesa, gtk2, cairo, pango, fftwFloat, zita-convolver }:

stdenv.mkDerivation rec {
  version = "20160619";
  name = "x42-plugins-${version}";

  src = fetchurl {
    url = "http://gareus.org/misc/x42-plugins/${name}.tar.xz";
    sha256 = "1ald0c5xbfkdq6g5xwyy8wmbi636m3k3gqrq16kbh46g0kld1as9";
  };

  buildInputs = [ xz mesa_glu ftgl freefont_ttf libjack2 libltc libsndfile libsamplerate lv2 mesa gtk2 cairo pango fftwFloat pkgconfig  zita-convolver];

  makeFlags = [ "PREFIX=$(out)" "FONTFILE=${freefont_ttf}/share/fonts/truetype/FreeSansBold.ttf" "LIBZITACONVOLVER=${zita-convolver}/include/zita-convolver.h" ];

  meta = with stdenv.lib;
    { description = "Collection of LV2 plugins by Robin Gareus";
      homepage = https://github.com/x42/x42-plugins;
      maintainers = with maintainers; [ magnetophon ];
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
}
