{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wayland,
  wayland-protocols,
  json_c,
  libxkbcommon,
  fontconfig,
  giflib,
  libheif,
  libjpeg,
  libwebp,
  libtiff,
  librsvg,
  libpng,
  libjxl,
  libexif,
  libavif,
  openexr_3,
  bash-completion,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "swayimg";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "artemsen";
    repo = "swayimg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bUU4s7nlN48rYMX4SleUDAOCVz2fowGctEfP6KhMdoA=";
  };

  strictDeps = true;

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  mesonFlags = [
    (lib.mesonOption "version" finalAttrs.version)
  ];

  buildInputs = [
    bash-completion
    wayland
    wayland-protocols
    json_c
    libxkbcommon
    fontconfig
    giflib
    libheif
    libjpeg
    libwebp
    libtiff
    librsvg
    libpng
    libjxl
    libexif
    libavif
    openexr_3
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = with lib; {
    homepage = "https://github.com/artemsen/swayimg";
    description = "Image viewer for Sway/Wayland";
    changelog = "https://github.com/artemsen/swayimg/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.linux;
    mainProgram = "swayimg";
  };
})
