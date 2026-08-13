{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  wlroots_0_20,
  scdoc,
  pkg-config,
  wayland,
  libdrm,
  libxkbcommon,
  pixman,
  wayland-protocols,
  lcms2,
  libGL,
  libgbm,
  libxcb,
  libxcb-wm,
  validatePkgConfig,
  testers,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scenefx";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "wlrfx";
    repo = "scenefx";
    tag = finalAttrs.version;
    hash = "sha256-vUjLG6eubEhJJVa9LPygIcVmNoHwYbSUTJcWEcbxnU4=";
  };

  __structuredAttrs = true;
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
    libgbm
    libxcb
    libxcb-wm
    libxkbcommon
    pixman
    wayland
    wayland-protocols
    wlroots_0_20
    lcms2
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "Drop-in replacement for the wlroots scene API that allows wayland compositors to render surfaces with eye-candy effects";
    homepage = finalAttrs.src.meta.homepage;
    changelog = "${finalAttrs.src.meta.homepage}/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      swarsel
      yvnth
    ];

    mainProgram = "scenefx";
    pkgConfigModules = [ "scenefx" ];
    platforms = lib.platforms.linux;
  };
})
