{ stdenv, fetchurl, pkgconfig
, libltc, libsndfile, libsamplerate, ftgl, freefont_ttf, libjack2
, mesa_glu, lv2, gtk2, cairo, pango, fftwFloat, zita-convolver }:

stdenv.mkDerivation rec {
  version = "20170428";
  name = "x42-plugins-${version}";

  src = fetchurl {
    url = "http://gareus.org/misc/x42-plugins/${name}.tar.xz";
    sha256 = "0yi82rak2277x4nzzr5zwbsnha5pi61w975c8src2iwar2b6m0xg";
  };

  buildInputs = [ mesa_glu ftgl freefont_ttf libjack2 libltc libsndfile libsamplerate lv2 gtk2 cairo pango fftwFloat pkgconfig  zita-convolver];

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
