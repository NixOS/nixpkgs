{ lib, stdenv, fetchurl, pkgconfig, libtool
, bzip2, zlib, libX11, libXext, libXt, fontconfig, freetype, ghostscript, libjpeg
, lcms2, openexr, libpng, librsvg, libtiff, libxml2
}:

let

  version = "6.9.1-0";

  arch =
    if stdenv.system == "i686-linux" then "i686"
    else if stdenv.system == "x86_64-linux" || stdenv.system == "x86_64-darwin" then "x86-64"
    else throw "ImageMagick is not supported on this platform.";

in

stdenv.mkDerivation rec {
  name = "imagemagick-${version}";

  src = fetchurl {
    url = "mirror://imagemagick/releases/ImageMagick-${version}.tar.xz";
    sha256 = "03lvj6rxv16xk0dpsbzvm2gq5bggkwff9wqbpkq0znihzijpax1j";
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
      openexr libpng librsvg libtiff libxml2
    ];

  postFixup = ''
    for file in $out/bin/Magick++-config $out/bin/Magick-config $out/bin/MagickCore-config $out/bin/MagickWand-config $out/bin/Wand-config; do
      substituteInPlace $file --replace pkg-config ${pkgconfig}/bin/pkg-config
    done
  '';

  propagatedBuildInputs =
    [ bzip2 freetype libjpeg libX11 libXext libXt lcms2 ];

  postInstall = ''(cd "$out/include" && ln -s ImageMagick* ImageMagick)'';

  meta = with stdenv.lib; {
    homepage = http://www.imagemagick.org/;
    description = "A software suite to create, edit, compose, or convert bitmap images";
    platforms = platforms.linux ++ [ "x86_64-darwin" ];
    maintainers = with maintainers; [ the-kenny wkennington ];
  };
}
