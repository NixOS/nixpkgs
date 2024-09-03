{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  wlroots_0_17,
  scdoc,
  pkg-config,
  wayland,
  libdrm,
  libxkbcommon,
  pixman,
  wayland-protocols,
  libGL,
  mesa,
  validatePkgConfig,
  testers,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scenefx";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "wlrfx";
    repo = "scenefx";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-vBmunqXwGbMNiGRd372TdMU4siWhIVYn5RVYne9C7uQ=";
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
    mesa
    pixman
    wayland
    wayland-protocols
    wlroots_0_17
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Drop-in replacement for the wlroots scene API that allows wayland compositors to render surfaces with eye-candy effects";
    homepage = "https://github.com/wlrfx/scenefx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    mainProgram = "scenefx";
    pkgConfigModules = [ "scenefx" ];
    platforms = lib.platforms.all;
  };
})
