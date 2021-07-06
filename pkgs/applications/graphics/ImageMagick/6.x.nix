{ lib, stdenv, fetchFromGitHub, pkg-config, libtool
, bzip2, zlib, libX11, libXext, libXt, fontconfig, freetype, ghostscript, libjpeg, djvulibre
, lcms2, openexr, libpng, liblqr1, librsvg, libtiff, libxml2, openjpeg, libwebp, fftw, libheif, libde265
, ApplicationServices, Foundation
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
  version = "6.9.12-17";

  src = fetchFromGitHub {
    owner = "ImageMagick";
    repo = "ImageMagick6";
    rev = version;
    sha256 = "sha256-yZXvxl9Tbl3JRBmRcfsjbkaxywtD08SuUnJayKfwk9M=";
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
    ++ lib.optionals (stdenv.hostPlatform.isMinGW)
      [ "--enable-static" "--disable-shared" ] # due to libxml2 being without DLLs ATM
    ;

  nativeBuildInputs = [ pkg-config libtool ];

  buildInputs =
    [ zlib fontconfig freetype ghostscript
      liblqr1 libpng libtiff libxml2 libheif libde265 djvulibre
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isMinGW)
      [ openexr librsvg openjpeg ]
    ++ lib.optionals stdenv.isDarwin
      [ ApplicationServices Foundation ];

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
    homepage = "https://legacy.imagemagick.org/";
    changelog = "https://legacy.imagemagick.org/script/changelog.php";
    description = "A software suite to create, edit, compose, or convert bitmap images";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ erictapen ];
    license = licenses.asl20;
  };
}
