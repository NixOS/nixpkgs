{stdenv, fetchurl, bzip2, freetype, graphviz, ghostscript
, libjpeg, libpng, libtiff, libxml2, zlib, libtool
, libX11}:

let version = "1.3.7"; in

stdenv.mkDerivation {
  name = "graphicsmagick-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/graphicsmagick/GraphicsMagick-${version}.tar.gz";
    sha256 = "0bwyqqvajz0hi34gfbjvm9f78icxk3fb442mvn8q2rapmvfpfkgf";
  };

  configureFlags = "--enable-shared";

  buildInputs =
    [ libpng bzip2 freetype ghostscript graphviz libjpeg libtiff libX11 libxml2
      zlib libtool
    ];

  postInstall = ''
    sed -i 's/-ltiff.*'\'/\'/ $out/bin/*
  '';

  meta = {
    homepage = http://www.graphicsmagick.org;
    description = "Swiss army knife of image processing";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
