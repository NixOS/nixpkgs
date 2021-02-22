{ lib, stdenv, fetchFromGitHub, pkg-config, libtool
, bzip2, zlib, libX11, libXext, libXt, fontconfig, freetype, ghostscript, libjpeg, djvulibre
, lcms2, openexr, libpng, librsvg, libtiff, libxml2, openjpeg, libwebp, fftw, libheif, libde265
, ApplicationServices
}:

let
  arch =
    if stdenv.hostPlatform.system == "i686-linux" then "i686"
    else if stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.system == "x86_64-darwin" then "x86-64"
    else if stdenv.hostPlatform.system == "armv7l-linux" then "armv7l"
    else if stdenv.hostPlatform.system == "aarch64-linux" then "aarch64"
    else if stdenv.hostPlatform.system == "powerpc64le-linux" then "ppc64le"
    else throw "ImageMagick is not supported on this platform.";
in

stdenv.mkDerivation rec {
  pname = "imagemagick";
  version = "6.9.11-60";

  src = fetchFromGitHub {
    owner = "ImageMagick";
    repo = "ImageMagick6";
    rev = version;
    sha256 = "12810882a0kf4zlgyi290z9bjs921m05njbljkjfw6s1hf0mncl0";
  };

  outputs = [ "out" "dev" "doc" ]; # bin/ isn't really big
  outputMan = "out"; # it's tiny

  enableParallelBuilding = true;

  configureFlags =
    [ "--with-frozenpaths" ]
    ++ [ "--with-gcc-arch=${arch}" ]
    ++ lib.optional (librsvg != null) "--with-rsvg"
    ++ lib.optionals (ghostscript != null)
      [ "--with-gs-font-dir=${ghostscript}/share/ghostscript/fonts"
        "--with-gslib"
      ]
    ++ lib.optionals (stdenv.hostPlatform.isMinGW)
      [ "--enable-static" "--disable-shared" ] # due to libxml2 being without DLLs ATM
    ;

  nativeBuildInputs = [ pkg-config libtool ];

  buildInputs =
    [ zlib fontconfig freetype ghostscript
      libpng libtiff libxml2 libheif libde265 djvulibre
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isMinGW)
      [ openexr librsvg openjpeg ]
    ++ lib.optional stdenv.isDarwin ApplicationServices;

  propagatedBuildInputs =
    [ bzip2 freetype libjpeg lcms2 fftw ]
    ++ lib.optionals (!stdenv.hostPlatform.isMinGW)
      [ libX11 libXext libXt libwebp ]
    ;

  doCheck = false; # fails 6 out of 76 tests

  postInstall = ''
    (cd "$dev/include" && ln -s ImageMagick* ImageMagick)
    moveToOutput "bin/*-config" "$dev"
    moveToOutput "lib/ImageMagick-*/config-Q16" "$dev" # includes configure params
    for file in "$dev"/bin/*-config; do
      substituteInPlace "$file" --replace "${pkg-config}/bin/pkg-config -config" \
        ${pkg-config}/bin/${pkg-config.targetPrefix}pkg-config
      substituteInPlace "$file" --replace ${pkg-config}/bin/pkg-config \
        "PKG_CONFIG_PATH='$dev/lib/pkgconfig' '${pkg-config}/bin/${pkg-config.targetPrefix}pkg-config'"
    done
  '' + lib.optionalString (ghostscript != null) ''
    for la in $out/lib/*.la; do
      sed 's|-lgs|-L${lib.getLib ghostscript}/lib -lgs|' -i $la
    done
  '';

  meta = with lib; {
    homepage = "http://www.imagemagick.org/";
    description = "A software suite to create, edit, compose, or convert bitmap images";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.asl20;
  };
}
