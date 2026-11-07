{
  lib,
  stdenv,
  fetchFromGitHub,
  bash-completion,
  exiv2,
  ffmpeg,
  fontconfig,
  giflib,
  json_c,
  libavif,
  libdrm,
  libheif,
  libjpeg,
  libjxl,
  libpng,
  libraw,
  librsvg,
  libsixel,
  libtiff,
  libwebp,
  libxkbcommon,
  luajit,
  meson,
  minizip-ng,
  ninja,
  nix-update-script,
  openexr,
  openjpeg,
  pkg-config,
  testers,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swayimg";
  version = "5.7";

  src = fetchFromGitHub {
    owner = "artemsen";
    repo = "swayimg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-peRcF/r45Nb/EAJaIM7xxgjK9M2guvXlhYYrfkm2svM=";
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
    exiv2
    ffmpeg
    fontconfig
    giflib
    json_c
    libavif
    libdrm
    libheif
    libjpeg
    libjxl
    libpng
    libraw
    librsvg
    libsixel
    libtiff
    libwebp
    libxkbcommon
    luajit
    minizip-ng
    openexr
    openjpeg
    wayland
    wayland-protocols
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };

    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/artemsen/swayimg";
    description = "Image viewer for Sway/Wayland";
    changelog = "https://github.com/artemsen/swayimg/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthewcroughan
      Gliczy
    ];
    platforms = lib.platforms.linux;
    mainProgram = "swayimg";
  };
})
