{ lib, stdenv, fetchFromGitHub, pkg-config, libtool
, bzip2, zlib, libX11, libXext, libXt, fontconfig, freetype, ghostscript, libjpeg, djvulibre
, lcms2, openexr, libpng, liblqr1, librsvg, libtiff, libxml2, openjpeg, libwebp, libheif
, ApplicationServices
, Foundation
, testVersion, imagemagick
}:

let
  arch =
    if stdenv.hostPlatform.system == "i686-linux" then "i686"
    else if stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.system == "x86_64-darwin" then "x86-64"
    else if stdenv.hostPlatform.system == "armv7l-linux" then "armv7l"
    else if stdenv.hostPlatform.system == "aarch64-linux"  || stdenv.hostPlatform.system == "aarch64-darwin" then "aarch64"
    else if stdenv.hostPlatform.system == "powerpc64le-linux" then "ppc64le"
    else null;
in

stdenv.mkDerivation rec {
  pname = "imagemagick";
  version = "7.1.0-2";

  src = fetchFromGitHub {
    owner = "ImageMagick";
    repo = "ImageMagick";
    rev = version;
    sha256 = "sha256-0nTz9UBspROrNj72amyZmFYK/y9Xg4+qNt4raZiK3AI=";
  };

  outputs = [ "out" "dev" "doc" ]; # bin/ isn't really big
  outputMan = "out"; # it's tiny

  enableParallelBuilding = true;

  configureFlags =
    [ "--with-frozenpaths" ]
    ++ (if arch != null then [ "--with-gcc-arch=${arch}" ] else [ "--without-gcc-arch" ])
    ++ lib.optional (librsvg != null) "--with-rsvg"
    ++ lib.optional (liblqr1 != null) "--with-lqr"
    ++ lib.optionals (ghostscript != null)
      [ "--with-gs-font-dir=${ghostscript}/share/ghostscript/fonts"
        "--with-gslib"
      ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW
      [ "--enable-static" "--disable-shared" ] # due to libxml2 being without DLLs ATM
    ;

  nativeBuildInputs = [ pkg-config libtool ];

  buildInputs =
    [ zlib fontconfig freetype ghostscript
      liblqr1 libpng libtiff libxml2 libheif djvulibre
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isMinGW)
      [ openexr librsvg openjpeg ]
    ++ lib.optionals stdenv.isDarwin [
      ApplicationServices
      Foundation
    ];

  propagatedBuildInputs =
    [ bzip2 freetype libjpeg lcms2 ]
    ++ lib.optionals (!stdenv.hostPlatform.isMinGW)
      [ libX11 libXext libXt libwebp ]
    ;

  postInstall = ''
    (cd "$dev/include" && ln -s ImageMagick* ImageMagick)
    moveToOutput "bin/*-config" "$dev"
    moveToOutput "lib/ImageMagick-*/config-Q16HDRI" "$dev" # includes configure params
    for file in "$dev"/bin/*-config; do
      substituteInPlace "$file" --replace pkg-config \
        "PKG_CONFIG_PATH='$dev/lib/pkgconfig' '${pkg-config}/bin/${pkg-config.targetPrefix}pkg-config'"
    done
  '' + lib.optionalString (ghostscript != null) ''
    for la in $out/lib/*.la; do
      sed 's|-lgs|-L${lib.getLib ghostscript}/lib -lgs|' -i $la
    done
  '';

  passthru.tests.version =
    testVersion { package = imagemagick; };

  meta = with lib; {
    homepage = "http://www.imagemagick.org/";
    description = "A software suite to create, edit, compose, or convert bitmap images";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ erictapen dotlambda ];
    license = licenses.asl20;
    mainProgram = "magick";
  };
}
