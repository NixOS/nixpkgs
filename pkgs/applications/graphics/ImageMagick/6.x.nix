{ lib, stdenv, fetchFromGitHub, pkg-config, libtool
, bzip2Support ? true, bzip2
, zlibSupport ? true, zlib
, libX11Support ? !stdenv.hostPlatform.isMinGW, libX11
, libXtSupport ? !stdenv.hostPlatform.isMinGW, libXt
, fontconfigSupport ? true, fontconfig
, freetypeSupport ? true, freetype
, ghostscriptSupport ? false, ghostscript
, libjpegSupport ? true, libjpeg
, djvulibreSupport ? true, djvulibre
, lcms2Support ? true, lcms2
, openexrSupport ? !stdenv.hostPlatform.isMinGW, openexr
, libpngSupport ? true, libpng
, liblqr1Support ? true, liblqr1
, librsvgSupport ? !stdenv.hostPlatform.isMinGW, librsvg
, libtiffSupport ? true, libtiff
, libxml2Support ? true, libxml2
, openjpegSupport ? !stdenv.hostPlatform.isMinGW, openjpeg
, libwebpSupport ? !stdenv.hostPlatform.isMinGW, libwebp
, libheifSupport ? true, libheif
, libde265Support ? true, libde265
, fftw
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
  version = "6.9.12-68";

  src = fetchFromGitHub {
    owner = "ImageMagick";
    repo = "ImageMagick6";
    rev = version;
    sha256 = "sha256-slQcA0cblxtG/1DiJx5swUh7Kfwgz5HG70eqJFLaQJI=";
  };

  outputs = [ "out" "dev" "doc" ]; # bin/ isn't really big
  outputMan = "out"; # it's tiny

  enableParallelBuilding = true;

  configureFlags = [
    "--with-frozenpaths"
    (lib.withFeatureAs (arch != null) "gcc-arch" arch)
    (lib.withFeature librsvgSupport "rsvg")
    (lib.withFeature liblqr1Support "lqr")
    (lib.withFeatureAs ghostscriptSupport "gs-font-dir" "${ghostscript}/share/ghostscript/fonts")
    (lib.withFeature ghostscriptSupport "gslib")
  ] ++ lib.optionals stdenv.hostPlatform.isMinGW [
    # due to libxml2 being without DLLs ATM
    "--enable-static" "--disable-shared"
  ];

  nativeBuildInputs = [ pkg-config libtool ];

  buildInputs = [ ]
    ++ lib.optional zlibSupport zlib
    ++ lib.optional fontconfigSupport fontconfig
    ++ lib.optional ghostscriptSupport ghostscript
    ++ lib.optional liblqr1Support liblqr1
    ++ lib.optional libpngSupport libpng
    ++ lib.optional libtiffSupport libtiff
    ++ lib.optional libxml2Support libxml2
    ++ lib.optional libheifSupport libheif
    ++ lib.optional libde265Support libde265
    ++ lib.optional djvulibreSupport djvulibre
    ++ lib.optional openexrSupport openexr
    ++ lib.optional librsvgSupport librsvg
    ++ lib.optional openjpegSupport openjpeg
    ++ lib.optionals stdenv.isDarwin [
      ApplicationServices
      Foundation
    ];

  propagatedBuildInputs = [ fftw ]
    ++ lib.optional bzip2Support bzip2
    ++ lib.optional freetypeSupport freetype
    ++ lib.optional libjpegSupport libjpeg
    ++ lib.optional lcms2Support lcms2
    ++ lib.optional libX11Support libX11
    ++ lib.optional libXtSupport libXt
    ++ lib.optional libwebpSupport libwebp;

  doCheck = false; # fails 2 out of 76 tests

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
  '' + lib.optionalString ghostscriptSupport ''
    for la in $out/lib/*.la; do
      sed 's|-lgs|-L${lib.getLib ghostscript}/lib -lgs|' -i $la
    done
  '';

  meta = with lib; {
    homepage = "https://legacy.imagemagick.org/";
    changelog = "https://legacy.imagemagick.org/script/changelog.php";
    description = "A software suite to create, edit, compose, or convert bitmap images";
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
  };
}
