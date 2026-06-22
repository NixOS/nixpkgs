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
  bash-completion,
  testers,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swayimg";
  version = "5.2";

  src = fetchFromGitHub {
    owner = "artemsen";
    repo = "swayimg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aDZ7Ka8uKVLzEwxS2CT5fRFNDf9z/LO3bB0dCMz1Mf0=";
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
