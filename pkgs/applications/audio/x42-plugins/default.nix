{ stdenv, fetchurl, pkgconfig
, libltc, libsndfile, libsamplerate, ftgl, freefont_ttf, libjack2
, libGLU, lv2, gtk2, cairo, pango, fftwFloat, zita-convolver }:

stdenv.mkDerivation rec {
  version = "20180803";
  name = "x42-plugins-${version}";

  src = fetchurl {
    url = "https://gareus.org/misc/x42-plugins/${name}.tar.xz";
    sha256 = "1v7p6vnkcbzyvmcysabhmn603cndzx9mwzaw5dppy4wd687vhgis";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libGLU ftgl freefont_ttf libjack2 libltc libsndfile libsamplerate lv2 gtk2 cairo pango fftwFloat zita-convolver ];

  # Don't remove this. The default fails with 'do not know how to unpack source archive'
  # every now and then on Hydra. No idea why.
  unpackPhase = ''
    tar xf $src
    sourceRoot=$(echo x42-plugins-*)
    chmod -R u+w $sourceRoot
  '';

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
