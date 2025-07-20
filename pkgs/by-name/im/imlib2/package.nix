{
  lib,
  stdenv,
  fetchurl,
  # Image file formats
  libjpeg,
  libtiff,
  giflib,
  libpng,
  libwebp,
  libjxl,
  libspectre,
  # imlib2 can load images from ID3 tags.
  libid3tag,
  librsvg,
  libheif,
  freetype,
  bzip2,
  pkg-config,
  x11Support ? true,
  webpSupport ? true,
  svgSupport ? false,
  heifSupport ? false,
  jxlSupport ? false,
  psSupport ? false,

  # for passthru.tests
  libcaca,
  diffoscopeMinimal,
  feh,
  icewm,
  openbox,
  fluxbox,
  enlightenment,
  xorg,
  testers,

  gitUpdater,
}:

let
  inherit (lib) optional optionals;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "imlib2";
  version = "1.12.5";

  src = fetchurl {
    url = "mirror://sourceforge/enlightenment/imlib2-${finalAttrs.version}.tar.xz";
    hash = "sha256-+iMV8oN5tDCm5mBbQoSwe+BqPvQi1PXhybskcUxM9t0=";
  };

  buildInputs = [
    libjpeg
    libtiff
    giflib
    libpng
    bzip2
    freetype
    libid3tag
  ]
  ++ optionals x11Support [
    xorg.libXft
    xorg.libXext
  ]
  ++ optional heifSupport libheif
  ++ optional svgSupport librsvg
  ++ optional webpSupport libwebp
  ++ optional jxlSupport libjxl
  ++ optional psSupport libspectre;

  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  # Do not build amd64 assembly code on Darwin, because it fails to compile
  # with unknown directive errors
  configureFlags =
    optional stdenv.hostPlatform.isDarwin "--enable-amd64=no"
    ++ optional (!svgSupport) "--without-svg"
    ++ optional (!heifSupport) "--without-heif"
    ++ optional (!x11Support) "--without-x";

  outputs = [
    "bin"
    "out"
    "dev"
  ];

  passthru = {
    tests = {
      inherit
        libcaca
        diffoscopeMinimal
        feh
        icewm
        openbox
        fluxbox
        enlightenment
        ;
      pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    };
    updateScript = gitUpdater {
      # No nicer place to find latest release.
      url = "https://git.enlightenment.org/old/legacy-imlib2.git";
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    description = "Image manipulation library";

    longDescription = ''
      This is the Imlib 2 library - a library that does image file loading and
      saving as well as rendering, manipulation, arbitrary polygon support, etc.
      It does ALL of these operations FAST. Imlib2 also tries to be highly
      intelligent about doing them, so writing naive programs can be done
      easily, without sacrificing speed.
    '';

    homepage = "https://docs.enlightenment.org/api/imlib2/html";
    changelog = "https://git.enlightenment.org/old/legacy-imlib2/raw/tag/v${finalAttrs.version}/ChangeLog";
    license = licenses.imlib2;
    pkgConfigModules = [ "imlib2" ];
    platforms = platforms.unix;
    maintainers = [ ];
  };
})
