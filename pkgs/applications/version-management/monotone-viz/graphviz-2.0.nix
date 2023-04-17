{ lib
, stdenv
, fetchurl
, pkg-config
, libX11
, libpng
, libjpeg
, expat
, libXaw
, bison
, libtool
, fontconfig
, pango
, gd
, libwebp
}:

stdenv.mkDerivation rec {
  pname = "graphviz";
  version = "2.0";

  src = fetchurl {
    url = "http://www.graphviz.org/pub/graphviz/ARCHIVE/graphviz-${version}.tar.gz";
    sha256 = "39b8e1f2ba4cc1f5bdc8e39c7be35e5f831253008e4ee2c176984f080416676c";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libX11
    libpng
    libjpeg
    expat
    libXaw
    bison
    libtool
    fontconfig
    pango
    gd
    libwebp
  ];

  hardeningDisable = [ "format" "fortify" ];

  configureFlags =
    [
      "--with-pngincludedir=${lib.getDev libpng}/include"
      "--with-pnglibdir=${libpng.out}/lib"
      "--with-jpegincludedir=${lib.getDev libjpeg}/include"
      "--with-jpeglibdir=${libjpeg.out}/lib"
      "--with-expatincludedir=${lib.getDev expat}/include"
      "--with-expatlibdir=${expat.out}/lib"
      "--with-ltdl-include=${lib.getDev libtool}/include"
      "--with-ltdl-lib=${libtool.lib}/lib"
    ]
    ++ lib.optional (libX11 == null) "--without-x";

  meta = {
    description = "A program for visualising graphs";
    homepage = "http://www.graphviz.org/";
    branch = "2.0";
    platforms = lib.platforms.unix;
  };
}
