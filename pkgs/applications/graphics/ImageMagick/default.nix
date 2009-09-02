args: with args;

let version = "6.5.5-6"; in

stdenv.mkDerivation (rec {
  name = "ImageMagick-${version}";

  src = fetchurl {
    url = "mirror://imagemagick/${name}.tar.bz2";
    sha256 = "1037nsvfpw7wdgsvvzvi0bn1n5d667d8aj1xam7zgmf7xi6xha3q";
  };

  configureFlags = ''
    --with-gs-font-dir=${ghostscript}/share/ghostscript/fonts
    --with-gslib
    ${if args ? tetex then "--with-frozenpaths" else ""}
  '';

  buildInputs =
    [ bzip2 freetype ghostscript graphviz libjpeg libpng
      libtiff libX11 libxml2 zlib libtool
    ]
    ++ stdenv.lib.optional (args ? tetex) args.tetex
    ++ stdenv.lib.optional (args ? librsvg) args.librsvg;

  preConfigure = if args ? tetex then
    ''
      export DVIDecodeDelegate=${args.tetex}/bin/dvips
    '' else "";

  meta = {
    homepage = http://www.imagemagick.org;
  };
})
