{ stdenv
, fetchurl
, bzip2
, freetype
, graphviz
, ghostscript
, libjpeg
, libpng
, libtiff
, libxml2
, zlib
, libtool
, jasper
, libX11
, tetex ? null
, librsvg ? null
}:

let
  version = "6.5.9-1";
in
stdenv.mkDerivation rec {
  name = "ImageMagick-${version}";

  src = fetchurl {
    url = "mirror://imagemagick/${name}.tar.bz2";
    sha256 = "0a4yhhfqagz28yccydngi31050101jfmq5ljln61g69yy6m47ifg";
  };

  configureFlags = ''
    --with-gs-font-dir=${ghostscript}/share/ghostscript/fonts
    --with-gslib
    ${if tetex != null then "--with-frozenpaths" else ""}
  '';

  buildInputs =
    [ bzip2 freetype graphviz ghostscript libjpeg libpng
      libtiff libxml2 zlib tetex librsvg libtool jasper libX11
    ];

  preConfigure = if tetex != null then
    ''
      export DVIDecodeDelegate=${tetex}/bin/dvips
    '' else "";

  meta = {
    homepage = http://www.imagemagick.org;
  };
}
