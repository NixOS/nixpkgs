{stdenv, fetchurl, bzip2, freetype, graphviz, ghostscript
, libjpeg, libpng, libtiff, libxml2, zlib, libtool, xz
, libX11, quantumdepth ? 8}:

let version = "1.3.18"; in

stdenv.mkDerivation {
  name = "graphicsmagick-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/graphicsmagick/GraphicsMagick-${version}.tar.xz";
    sha256 = "1axh4j2jr3l92dan15b2nmx9da4l7i0rcz9b5bvfd4q742zfwj7x";
  };

  configureFlags = "--enable-shared --with-quantum-depth=" + toString quantumdepth;

  buildInputs =
    [ bzip2 freetype ghostscript graphviz libjpeg libpng libtiff libX11 libxml2
      zlib libtool
    ];

  nativeBuildInputs = [ xz ];

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
