{stdenv, fetchurl, bzip2, freetype, graphviz, ghostscript
, libjpeg, libpng, libtiff, libxml2, zlib, libtool, xz
, libX11, libwebp, quantumdepth ? 8}:

let version = "1.3.23"; in

stdenv.mkDerivation {
  name = "graphicsmagick-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/graphicsmagick/GraphicsMagick-${version}.tar.xz";
    sha256 = "03g6l2h8cmf231y1vma0z7x85070jm1ysgs9ppqcd3jj56jka9gx";
  };

  patches = [ ./disable-popen.patch ];

  configureFlags = [
    "--enable-shared"
    "--with-quantum-depth=${toString quantumdepth}"
    "--with-gslib=yes"
  ];

  buildInputs =
    [ bzip2 freetype ghostscript graphviz libjpeg libpng libtiff libX11 libxml2
      zlib libtool libwebp
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
