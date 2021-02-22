{ lib, stdenv, fetchurl, bzip2, freetype, graphviz, ghostscript
, libjpeg, libpng, libtiff, libxml2, zlib, libtool, xz, libX11
, libwebp, quantumdepth ? 8, fixDarwinDylibNames }:

stdenv.mkDerivation rec {
  pname = "graphicsmagick";
  version = "1.3.36";

  src = fetchurl {
    url = "mirror://sourceforge/graphicsmagick/GraphicsMagick-${version}.tar.xz";
    sha256 = "0ilg6fkppb4avzais1dvi3qf6ln7v3mzj7gjm83w7pwwfpg3ynsx";
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
    ];

  nativeBuildInputs = [ xz ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  postInstall = ''
    sed -i 's/-ltiff.*'\'/\'/ $out/bin/*
  '';

  meta = {
    homepage = "http://www.graphicsmagick.org";
    description = "Swiss army knife of image processing";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
