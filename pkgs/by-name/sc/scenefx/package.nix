{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  wlroots_0_19,
  scdoc,
  pkg-config,
  wayland,
  libdrm,
  libxkbcommon,
  pixman,
  wayland-protocols,
  libGL,
  libgbm,
  libxcb,
  xcbutilwm,
  validatePkgConfig,
  testers,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scenefx";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "wlrfx";
    repo = "scenefx";
    tag = finalAttrs.version;
    hash = "sha256-XD5EcquaHBg5spsN06fPHAjVCb1vOMM7oxmjZZ/PxIE=";
  };

  strictDeps = true;

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    validatePkgConfig
    wayland-scanner
  ];

  buildInputs = [
    libdrm
    libGL
    libxkbcommon
    libgbm
    libxcb
    xcbutilwm
    pixman
    wayland
    wayland-protocols
    wlroots_0_19
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Drop-in replacement for the wlroots scene API that allows wayland compositors to render surfaces with eye-candy effects";
    homepage = "https://github.com/wlrfx/scenefx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "scenefx";
    pkgConfigModules = [ "scenefx" ];
    platforms = lib.platforms.all;
  };
})
