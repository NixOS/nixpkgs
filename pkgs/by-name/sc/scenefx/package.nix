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
  libGL,
  libgbm,
  libxcb,
  libxcb-wm,
  lcms2,
  validatePkgConfig,
  testers,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "scenefx";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "wlrfx";
    repo = "scenefx";
    tag = finalAttrs.version;
    hash = "sha256-vUjLG6eubEhJJVa9LPygIcVmNoHwYbSUTJcWEcbxnU4=";
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
    libxcb-wm
    pixman
    wayland
    wayland-protocols
    wlroots_0_20
    lcms2
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    changelog = "${finalAttrs.src.meta.homepage}/releases/tag/${finalAttrs.version}";
    description = "Drop-in replacement for the wlroots scene API that allows wayland compositors to render surfaces with eye-candy effects";
    homepage = finalAttrs.src.meta.homepage;
    license = lib.licenses.mit;
    mainProgram = "scenefx";
    maintainers = with lib.maintainers; [
      swarsel
      yvnth
    ];
    pkgConfigModules = [ "scenefx-${lib.versions.majorMinor finalAttrs.version}" ];
    platforms = lib.platforms.all;
  };
})
