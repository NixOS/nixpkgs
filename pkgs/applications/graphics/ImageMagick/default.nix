{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, libtool
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
, libjxlSupport ? true, libjxl
, libpngSupport ? true, libpng
, liblqr1Support ? true, liblqr1
, librawSupport ? true, libraw
, librsvgSupport ? !stdenv.hostPlatform.isMinGW, librsvg, pango
, libtiffSupport ? true, libtiff
, libxml2Support ? true, libxml2
, openjpegSupport ? !stdenv.hostPlatform.isMinGW, openjpeg
, libwebpSupport ? !stdenv.hostPlatform.isMinGW, libwebp
, libheifSupport ? true, libheif
, potrace
, curl
, ApplicationServices
, Foundation
, testers
, imagemagick
, nixos-icons
, perlPackages
, python3
}:

assert libXtSupport -> libX11Support;

let
  arch =
    if stdenv.hostPlatform.system == "i686-linux" then "i686"
    else if stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.system == "x86_64-darwin" then "x86-64"
    else if stdenv.hostPlatform.system == "armv7l-linux" then "armv7l"
    else if stdenv.hostPlatform.system == "aarch64-linux" || stdenv.hostPlatform.system == "aarch64-darwin" then "aarch64"
    else if stdenv.hostPlatform.system == "powerpc64le-linux" then "ppc64le"
    else null;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "imagemagick";
  version = "7.1.1-30";

  src = fetchFromGitHub {
    owner = "ImageMagick";
    repo = "ImageMagick";
    rev = finalAttrs.version;
    hash = "sha256-btXl1J/WjV+5BZibgUzylVmBrhR3KBK/ZSbP0B2fM5c=";
  };

  outputs = [ "out" "dev" "doc" ]; # bin/ isn't really big
  outputMan = "out"; # it's tiny

  enableParallelBuilding = true;

  configureFlags = [
    "--with-frozenpaths"
    (lib.withFeatureAs (arch != null) "gcc-arch" arch)
    (lib.withFeature librsvgSupport "rsvg")
    (lib.withFeature librsvgSupport "pango")
    (lib.withFeature liblqr1Support "lqr")
    (lib.withFeature libjxlSupport "jxl")
    (lib.withFeatureAs ghostscriptSupport "gs-font-dir" "${ghostscript}/share/ghostscript/fonts")
    (lib.withFeature ghostscriptSupport "gslib")
  ] ++ lib.optionals stdenv.hostPlatform.isMinGW [
    # due to libxml2 being without DLLs ATM
    "--enable-static" "--disable-shared"
  ];

  nativeBuildInputs = [ pkg-config libtool ];

  buildInputs = [ potrace ]
    ++ lib.optional zlibSupport zlib
    ++ lib.optional fontconfigSupport fontconfig
    ++ lib.optional ghostscriptSupport ghostscript
    ++ lib.optional liblqr1Support liblqr1
    ++ lib.optional libpngSupport libpng
    ++ lib.optional librawSupport libraw
    ++ lib.optional libtiffSupport libtiff
    ++ lib.optional libxml2Support libxml2
    ++ lib.optional libheifSupport libheif
    ++ lib.optional djvulibreSupport djvulibre
    ++ lib.optional libjxlSupport libjxl
    ++ lib.optional openexrSupport openexr
    ++ lib.optionals librsvgSupport [
      librsvg
      pango
    ]
    ++ lib.optional openjpegSupport openjpeg
    ++ lib.optionals stdenv.isDarwin [
      ApplicationServices
      Foundation
    ];

  propagatedBuildInputs = [ curl ]
    ++ lib.optional bzip2Support bzip2
    ++ lib.optional freetypeSupport freetype
    ++ lib.optional libjpegSupport libjpeg
    ++ lib.optional lcms2Support lcms2
    ++ lib.optional libX11Support libX11
    ++ lib.optional libXtSupport libXt
    ++ lib.optional libwebpSupport libwebp;

  postInstall = ''
    (cd "$dev/include" && ln -s ImageMagick* ImageMagick)
    moveToOutput "bin/*-config" "$dev"
    moveToOutput "lib/ImageMagick-*/config-Q16HDRI" "$dev" # includes configure params
    for file in "$dev"/bin/*-config; do
      substituteInPlace "$file" --replace pkg-config \
        "PKG_CONFIG_PATH='$dev/lib/pkgconfig' '$(command -v $PKG_CONFIG)'"
    done
  '' + lib.optionalString ghostscriptSupport ''
    for la in $out/lib/*.la; do
      sed 's|-lgs|-L${lib.getLib ghostscript}/lib -lgs|' -i $la
    done
  '';

  passthru.tests = {
    version = testers.testVersion { package = finalAttrs.finalPackage; };
    inherit nixos-icons;
    inherit (perlPackages) ImageMagick;
    inherit (python3.pkgs) img2pdf;
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    homepage = "http://www.imagemagick.org/";
    changelog = "https://github.com/ImageMagick/Website/blob/main/ChangeLog.md";
    description = "A software suite to create, edit, compose, or convert bitmap images";
    pkgConfigModules = [ "ImageMagick" "MagickWand" ];
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ erictapen dotlambda rhendric ];
    license = licenses.asl20;
    mainProgram = "magick";
  };
})
