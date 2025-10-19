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
  libconfig,
  gnuplot,
  opencv4,
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
  libjpeg,
  libheif,
  ffms,
  wrapGAppsHook3,
  curl,
  versionCheckHook,
  nix-update-script,
  gtksourceview4,
  lcms2,
  gettext,
  desktop-file-utils,
  appstream-glib,
  yyjson,
  libjxl,
  libxisf,
  libgit2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "siril";
  version = "1.4.0-beta4";

  src = fetchFromGitLab {
    owner = "free-astro";
    repo = "siril";
    tag = finalAttrs.version;
    hash = "sha256-oWw8LmcFXQkbpZz1Vvo1MSCRjAa3WexHrKGsJWpZnIA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    git
    criterion
    wrapGAppsHook3
    gettext
    desktop-file-utils
    appstream-glib
  ];

  buildInputs = [
    gtk3
    cfitsio
    gsl
    exiv2
    gnuplot
    opencv4
    fftwFloat
    librtprocess
    wcslib
    libconfig
    libraw
    libtiff
    libpng
    libjpeg
    libheif
    ffms
    ffmpeg
    json-glib
    curl
    gtksourceview4
    lcms2
    yyjson
    libjxl
    libxisf
    libgit2
  ];

  # Necessary because project uses default build dir for flatpaks/snaps
  dontUseMesonConfigure = true;
  dontUseCmakeConfigure = true;

  # Meson fails to find libcurl unless the option is specifically enabled
  configureScript = ''
    ${meson}/bin/meson setup -Dlibcurl=true --buildtype release nixbld .
  '';

  postConfigure = ''
    cd nixbld
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
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
  };
})
