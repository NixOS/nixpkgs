{ stdenv, fetchurl, bzip2, freetype, graphviz, ghostscript
, libjpeg, libpng, libtiff, libxml2, zlib, libtool, xz, libX11
, libwebp, quantumdepth ? 8, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "graphicsmagick";
  version = "1.3.35";

  src = fetchurl {
    url = "mirror://sourceforge/graphicsmagick/GraphicsMagick-${version}.tar.xz";
    sha256 = "0l024l4hawm9s3jqrgi2j0lxgm61dqh8sgkj1017ma7y11hqv2hq";
  };

  patches = [
    ./disable-popen.patch
  ];

  configureFlags = [
    "--enable-shared"
    "--with-quantum-depth=${toString quantumdepth}"
    "--with-gslib=yes"
  ];

  buildInputs =
    [ bzip2 freetype ghostscript graphviz libjpeg libpng libtiff libX11 libxml2
      zlib libtool libwebp
    ]
    ++ stdenv.lib.optional stdenv.isDarwin fixDarwinDylibNames;

  nativeBuildInputs = [ xz ];

  postInstall = ''
    sed -i 's/-ltiff.*'\'/\'/ $out/bin/*
  '';

  meta = {
    homepage = "http://www.graphicsmagick.org";
    description = "Swiss army knife of image processing";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
