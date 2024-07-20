{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  wlroots,
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

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    validatePkgConfig
  ];

  buildInputs = [
    libdrm
    libGL
    libxkbcommon
    mesa
    pixman
    wayland
    wayland-protocols
    wlroots
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
