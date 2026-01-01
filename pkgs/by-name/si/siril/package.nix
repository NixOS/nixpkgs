{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  meson,
  ninja,
  cmake,
  git,
  criterion,
  gtk3,
<<<<<<< HEAD
  gtksourceview4,
  libconfig,
  gnuplot,
  opencv,
  python3,
=======
  libconfig,
  gnuplot,
  opencv,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  json-glib,
  fftwFloat,
  cfitsio,
  gsl,
  exiv2,
  librtprocess,
  wcslib,
  ffmpeg,
  libraw,
  libtiff,
  libpng,
<<<<<<< HEAD
  libgit2,
  libjpeg,
  libjxl,
  libheif,
  libxisf,
  ffms,
  wrapGAppsHook3,
  curl,
  yyjson,
=======
  libjpeg,
  libheif,
  ffms,
  wrapGAppsHook3,
  curl,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "siril";
<<<<<<< HEAD
  version = "1.4.0";
=======
  version = "1.2.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    owner = "free-astro";
    repo = "siril";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-qE1K3/o7ubrIEWldRgus1quSVehJqjFxhsKb1HQPNLA=";
=======
    hash = "sha256-pSJp4Oj8x4pKuwPSaSyGbyGfpnanoWBxAdXtzGTP7uA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    git
    criterion
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    cfitsio
    gsl
    exiv2
    gnuplot
<<<<<<< HEAD
    gtksourceview4
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    opencv
    fftwFloat
    librtprocess
    wcslib
    libconfig
    libraw
    libtiff
    libpng
<<<<<<< HEAD
    libgit2
    libjpeg
    libjxl
    libheif
    libxisf
=======
    libjpeg
    libheif
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ffms
    ffmpeg
    json-glib
    curl
<<<<<<< HEAD
    yyjson
  ];

  propagatedBuildInputs = [ python3 ];

  # Necessary because project uses default build dir for flatpaks/snaps
  mesonBuildDir = "nixbld";
=======
  ];

  # Necessary because project uses default build dir for flatpaks/snaps
  dontUseMesonConfigure = true;
  dontUseCmakeConfigure = true;

  # Meson fails to find libcurl unless the option is specifically enabled
  configureScript = ''
    ${meson}/bin/meson setup -Denable-libcurl=yes --buildtype release nixbld .
  '';

  postConfigure = ''
    cd nixbld
  '';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://www.siril.org/";
    description = "Astrophotographic image processing tool";
    license = lib.licenses.gpl3Plus;
    changelog = "https://gitlab.com/free-astro/siril/-/blob/HEAD/ChangeLog";
    maintainers = with lib.maintainers; [
      returntoreality
    ];
    platforms = lib.platforms.linux;
<<<<<<< HEAD
    mainProgram = "siril";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
