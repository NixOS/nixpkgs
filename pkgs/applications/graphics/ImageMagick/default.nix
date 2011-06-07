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
, xz
, tetex ? null
, librsvg ? null
}:

let
  version = "6.6.9-4";
in
stdenv.mkDerivation rec {
  name = "ImageMagick-${version}";

  src = fetchurl {
    url = "mirror://imagemagick/${name}.tar.xz";
    sha256 = "035j3i3cm29bwc9lipn838gznswrc69g7mwh8h9jj24ss2dmqrf1";
  };

  configureFlags = ''
    --with-gs-font-dir=${ghostscript}/share/ghostscript/fonts
    --with-gslib
    --with-frozenpaths
    ${if librsvg != null then "--with-rsvg" else ""}
  '';

  propagatedBuildInputs =
    [ bzip2 freetype ghostscript libjpeg libpng libtiff libxml2 zlib librsvg
    libtool jasper libX11 ];

  buildInputs = [ tetex graphviz ];

  buildNativeInputs = [ xz ];

  preConfigure = if tetex != null then
    ''
      export DVIDecodeDelegate=${tetex}/bin/dvips
    '' else "";

  meta = {
    homepage = http://www.imagemagick.org;
  };
}
