{ lib, stdenv, fetchurl, pkgconfig, libtool
, bzip2, zlib, libX11, libXext, libXt, fontconfig, freetype, ghostscript, libjpeg
, lcms2, openexr, libpng, librsvg, libtiff, libxml2, openjpeg
}:

let
  arch =
    if stdenv.system == "i686-linux" then "i686"
    else if stdenv.system == "x86_64-linux" || stdenv.system == "x86_64-darwin" then "x86-64"
    else if stdenv.system == "armv7l-linux" then "armv7l"
    else throw "ImageMagick is not supported on this platform.";
in

stdenv.mkDerivation rec {
  name = "imagemagick-${version}";
  version = "6.9.3-8";

  src = fetchurl {
    urls = [
      "mirror://imagemagick/releases/ImageMagick-${version}.tar.xz"
      # the original source above removes tarballs quickly
      "http://distfiles.macports.org/ImageMagick/ImageMagick-${version}.tar.xz"
    ];
    sha256 = "129s4cwp6cbhgsr3xr8186q5j02zpbk6kqfk4j7ayb563zsrdb4h";
  };

  outputs = [ "out" "doc" ];

  enableParallelBuilding = true;

  configureFlags =
    [ "--with-frozenpaths" ]
    ++ [ "--with-gcc-arch=${arch}" ]
    ++ lib.optional (librsvg != null) "--with-rsvg"
    ++ lib.optionals (ghostscript != null)
      [ "--with-gs-font-dir=${ghostscript}/share/ghostscript/fonts"
        "--with-gslib"
      ];

  buildInputs =
    [ pkgconfig libtool zlib fontconfig freetype ghostscript libjpeg
      openexr libpng librsvg libtiff libxml2 openjpeg
    ];

  propagatedBuildInputs =
    [ bzip2 freetype libjpeg libX11 libXext libXt lcms2 ];

  postInstall = ''
    (cd "$out/include" && ln -s ImageMagick* ImageMagick)
  '' + lib.optionalString (ghostscript != null) ''
    for la in $out/lib/*.la; do
      sed 's|-lgs|-L${ghostscript}/lib -lgs|' -i $la
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.imagemagick.org/;
    description = "A software suite to create, edit, compose, or convert bitmap images";
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
    maintainers = with maintainers; [ the-kenny wkennington ];
  };
}
