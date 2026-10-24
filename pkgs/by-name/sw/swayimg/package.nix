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
  exiv2,
  fontconfig,
  giflib,
  ffmpeg,
  libheif,
  libjpeg,
  libwebp,
  libtiff,
  librsvg,
  libpng,
  libjxl,
  libavif,
  libsixel,
  libraw,
  libdrm,
  luajit,
  openexr,
  openjpeg,
  bash-completion,
  testers,
  nix-update-script,
  minizip-ng,
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
    wayland
    wayland-protocols
    json_c
    libxkbcommon
    exiv2
    fontconfig
    giflib
    ffmpeg
    libheif
    libjpeg
    libwebp
    libtiff
    librsvg
    libpng
    libjxl
    libavif
    libsixel
    libraw
    libdrm
    luajit
    openexr
    openjpeg
    minizip-ng
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
