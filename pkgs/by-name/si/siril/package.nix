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
  gtksourceview4,
  libconfig,
  gnuplot,
  opencv,
  python3,
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
  libgit2,
  libjpeg,
  libjxl,
  libheif,
  libxisf,
  ffms,
  wrapGAppsHook3,
  curl,
  yyjson,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "siril";
  version = "1.4.0";

  src = fetchFromGitLab {
    owner = "free-astro";
    repo = "siril";
    tag = finalAttrs.version;
    hash = "sha256-qE1K3/o7ubrIEWldRgus1quSVehJqjFxhsKb1HQPNLA=";
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
    gtksourceview4
    opencv
    fftwFloat
    librtprocess
    wcslib
    libconfig
    libraw
    libtiff
    libpng
    libgit2
    libjpeg
    libjxl
    libheif
    libxisf
    ffms
    ffmpeg
    json-glib
    curl
    yyjson
  ];

  propagatedBuildInputs = [ python3 ];

  # Necessary because project uses default build dir for flatpaks/snaps
  mesonBuildDir = "nixbld";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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
    mainProgram = "siril";
  };
})
