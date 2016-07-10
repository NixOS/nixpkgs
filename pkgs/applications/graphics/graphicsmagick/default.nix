{stdenv, fetchurl, bzip2, freetype, graphviz, ghostscript
, libjpeg, libpng, libtiff, libxml2, zlib, libtool, xz
, libX11, quantumdepth ? 8}:

let version = "1.3.24"; in

stdenv.mkDerivation {
  name = "graphicsmagick-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/graphicsmagick/GraphicsMagick-${version}.tar.xz";
    sha256 = "1q40w5hcl8rcpszm0r7rpr3a9lj390p39zfvavkvlgxyyk7bmgsj";
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
