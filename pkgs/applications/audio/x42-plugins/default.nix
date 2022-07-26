{ lib, stdenv, fetchurl, pkg-config
, libltc, libsndfile, libsamplerate, ftgl, freefont_ttf, libjack2
, libGLU, lv2, gtk2, cairo, pango, fftwFloat, zita-convolver }:

stdenv.mkDerivation rec {
  version = "20220327";
  pname = "x42-plugins";

  src = fetchurl {
    url = "https://gareus.org/misc/x42-plugins/${pname}-${version}.tar.xz";
    sha256 = "sha256-IhuPqTlCbCxExT5B9Au42RQQl4sDEvz6+HhsuT02KVs=";
  };

  nativeBuildInputs = [ pkg-config ];
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
    patchShebangs ./matrixmixer.lv2/genttl.sh
    patchShebangs ./matrixmixer.lv2/genhead.sh
    sed -i 's|/usr/include/zita-convolver.h|${zita-convolver}/include/zita-convolver.h|g' ./convoLV2/Makefile
  '';

  meta = with lib;
    { description = "Collection of LV2 plugins by Robin Gareus";
      homepage = "https://github.com/x42/x42-plugins";
      maintainers = with maintainers; [ magnetophon ];
      license = licenses.gpl2;
      platforms = [ "i686-linux" "x86_64-linux" ];
    };
}
