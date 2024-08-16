{ lib
, bzip2
, callPackage
, coreutils
, fetchurl
, fixDarwinDylibNames
, freetype
, ghostscript
, graphviz
, libX11
, libjpeg
, libpng
, libtiff
, libtool
, libwebp
, libxml2
, nukeReferences
, pkg-config
, quantumdepth ? 8
, runCommand
, stdenv
, xz
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graphicsmagick";
  version = "1.3.43";

  src = fetchurl {
    url = "mirror://sourceforge/graphicsmagick/GraphicsMagick-${finalAttrs.version}.tar.xz";
    hash = "sha256-K4hYBzLNfkCdniLGEWI4vvSuBvzaEUUb8z0ln5y/OZ8=";
  };

  outputs = [ "out" "man" ];

  buildInputs = [
    bzip2
    freetype
    ghostscript
    graphviz
    libX11
    libjpeg
    libpng
    libtiff
    libtool
    libwebp
    libxml2
    zlib
  ];

  nativeBuildInputs = [
    nukeReferences
    pkg-config
    xz
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  configureFlags = [
    # specify delegates explicitly otherwise `gm` will invoke the build
    # coreutils for filetypes it doesn't natively support.
    "MVDelegate=${lib.getExe' coreutils "mv"}"
    (lib.enableFeature true "shared")
    (lib.withFeature true "frozenpaths")
    (lib.withFeatureAs true "quantum-depth" (toString quantumdepth))
    (lib.withFeatureAs true "gslib" "yes")
  ];

  # Remove CFLAGS from the binaries to avoid closure bloat.
  # In the past we have had -dev packages in the closure of the binaries soley
  # due to the string references.
  postConfigure = ''
    nuke-refs -e $out ./magick/magick_config.h
  '';

  postInstall = ''
    sed -i 's/-ltiff.*'\'/\'/ $out/bin/*
  '';

  passthru = {
    imagemagick-compat = callPackage ./imagemagick-compat.nix {
      graphicsmagick = finalAttrs.finalPackage;
    };
    tests = {
      issue-157920 = runCommand "issue-157920-regression-test" {
        buildInputs = [ finalAttrs.finalPackage ];
      } ''
        gm convert ${graphviz}/share/doc/graphviz/neatoguide.pdf jpg:$out
      '';
    };
  };

  meta = {
    homepage = "http://www.graphicsmagick.org";
    description = "Swiss army knife of image processing";
    longDescription = ''
      GraphicsMagick is the swiss army knife of image processing, providing a
      robust and efficient collection of tools and libraries which support
      reading, writing, and manipulating an image in over 92 major formats
      including important formats like DPX, GIF, JPEG, JPEG-2000, JXL, PNG, PDF,
      PNM, TIFF, and WebP.
    '';
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    mainProgram = "gm";
    platforms = lib.platforms.all;
  };
})
