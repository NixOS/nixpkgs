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
  opencv,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "siril";
  version = "1.2.6";

  src = fetchFromGitLab {
    owner = "free-astro";
    repo = "siril";
    tag = finalAttrs.version;
    hash = "sha256-pSJp4Oj8x4pKuwPSaSyGbyGfpnanoWBxAdXtzGTP7uA=";
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
    opencv
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
      hjones2199
      returntoreality
    ];
    platforms = lib.platforms.linux;
  };
})
