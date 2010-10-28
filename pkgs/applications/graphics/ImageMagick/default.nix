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
  version = "6.6.5-4";
in
stdenv.mkDerivation rec {
  name = "ImageMagick-${version}";

  src = fetchurl {
    url = "mirror://imagemagick/${name}.tar.bz2";
    sha256 = "1s3l98xc1gnxi2wdg3sy9723f6qf5yk81wln8ghn2z9kvi09w7gw";
  };

  configureFlags = ''
    --with-gs-font-dir=${ghostscript}/share/ghostscript/fonts
    --with-gslib
    --with-frozenpaths
    ${if librsvg != null then "--with-rsvg" else ""}
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
