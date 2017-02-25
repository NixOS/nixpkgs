{ stdenv, fetchurl, pkgconfig
, libltc, libsndfile, libsamplerate, ftgl, freefont_ttf, libjack2
, mesa_glu, lv2, mesa, gtk2, cairo, pango, fftwFloat, zita-convolver }:

stdenv.mkDerivation rec {
  version = "20161230";
  name = "x42-plugins-${version}";

  src = fetchurl {
    url = "http://gareus.org/misc/x42-plugins/${name}.tar.xz";
    sha256 = "1yni9c17kl2pi9lqxip07b6g6lyfii1pch5czp183113gk54fwj5";
  };

  buildInputs = [ mesa_glu ftgl freefont_ttf libjack2 libltc libsndfile libsamplerate lv2 mesa gtk2 cairo pango fftwFloat pkgconfig  zita-convolver];

  makeFlags = [ "PREFIX=$(out)" "FONTFILE=${freefont_ttf}/share/fonts/truetype/FreeSansBold.ttf" ];

  patchPhase = ''
    patchShebangs ./stepseq.lv2/gridgen.sh
    sed -i 's|/usr/include/zita-convolver.h|${zita-convolver}/include/zita-convolver.h|g' ./convoLV2/Makefile
  '';

  meta = with stdenv.lib;
    { description = "Collection of LV2 plugins by Robin Gareus";
      homepage = https://github.com/x42/x42-plugins;
      maintainers = with maintainers; [ magnetophon ];
      license = licenses.gpl2;
      platforms = platforms.linux;
    };
}
