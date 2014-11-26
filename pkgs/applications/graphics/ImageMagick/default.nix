{ lib
, stdenv
, fetchurl
, pkgconfig
, bzip2
, fontconfig
, freetype
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

  version = "6.8.9-8";

  arch =
    if stdenv.system == "i686-linux" then "i686"
    else if stdenv.system == "x86_64-linux" || stdenv.system == "x86_64-darwin" then "x86-64"
    else throw "ImageMagick is not supported on this platform.";

in

stdenv.mkDerivation rec {
  name = "ImageMagick-${version}";

  src = fetchurl {
    url = "mirror://imagemagick/releases/${name}.tar.xz";
    sha256 = "1c792hbwi308lm9xkml319xaa4w3bz6hwy6i92jwrm7kqr4h8di7";
  };

  enableParallelBuilding = true;

  preConfigure = if tetex != null then
    ''
      export DVIDecodeDelegate=${tetex}/bin/dvips
    '' else "";

  configureFlags =
    [ "--with-frozenpaths" ]
    ++ [ "--with-gcc-arch=${arch}" ]
    ++ lib.optional (librsvg != null) "--with-rsvg"
    ++ lib.optionals (stdenv.system != "x86_64-darwin")
      [ "--with-gs-font-dir=${ghostscript}/share/ghostscript/fonts"
        "--with-gslib"
      ];

  propagatedBuildInputs =
    [ bzip2 fontconfig freetype libjpeg libpng libtiff libxml2 zlib librsvg
      libtool jasper libX11
    ] ++ lib.optional (stdenv.system != "x86_64-darwin") ghostscript;

  buildInputs = [ tetex pkgconfig ];

  postInstall = ''(cd "$out/include" && ln -s ImageMagick* ImageMagick)'';

  meta = with stdenv.lib; {
    homepage = http://www.imagemagick.org/;
    description = "A software suite to create, edit, compose, or convert bitmap images";
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
    maintainers = with maintainers; [ the-kenny ];
  };
}
