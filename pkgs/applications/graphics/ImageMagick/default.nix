{ stdenv
, fetchurl
, bzip2
, freetype
, graphviz
, ghostscript ? null
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
  version = "6.7.5-3";
in
stdenv.mkDerivation rec {
  name = "ImageMagick-${version}";

  src = fetchurl {
    url = "mirror://imagemagick/${name}.tar.xz";
    sha256 = "0m0sa4jxsvm8pf9nfvkzlbzq13d1lj15lfz6jif12l6ywyh2c1cs";
  };

  configureFlags = "" + stdenv.lib.optionalString (ghostscript != null && stdenv.system != "x86_64-darwin") ''
    --with-gs-font-dir=${ghostscript}/share/ghostscript/fonts
    --with-gslib
  '' + ''
    --with-frozenpaths
    ${if librsvg != null then "--with-rsvg" else ""}
  '';

  propagatedBuildInputs =
    [ bzip2 freetype libjpeg libpng libtiff libxml2 zlib librsvg
    libtool jasper libX11 ] ++ stdenv.lib.optional (ghostscript != null && stdenv.system != "x86_64-darwin") ghostscript;

  buildInputs = [ tetex graphviz ];

  preConfigure = if tetex != null then
    ''
      export DVIDecodeDelegate=${tetex}/bin/dvips
    '' else "";

  meta = {
    homepage = http://www.imagemagick.org/;
    description = "A software suite to create, edit, compose, or convert bitmap images";
    platforms = stdenv.lib.platforms.linux;
  };
}
