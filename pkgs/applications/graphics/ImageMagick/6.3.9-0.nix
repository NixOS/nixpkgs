args: with args;

stdenv.mkDerivation (rec {
  name = "ImageMagick-${version}";

  src = fetchurl {
    urls = [
      "ftp://ftp.imagemagick.org/pub/ImageMagick/${name}.tar.bz2"
      "http://ftp.surfnet.nl/pub/ImageMagick/${name}.tar.bz2"
    ];
    sha256 = "0ynn8gxixjb16xhg60hp2sbfymh03y5qxxgffwlchciiylw9dlvd";
  };

  configureFlags = ''
    --with-dots
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
