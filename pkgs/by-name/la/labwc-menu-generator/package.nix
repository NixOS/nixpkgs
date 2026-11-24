{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  pkg-config,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc-menu-generator";
  version = "0.2.2-unstable-2026-11-15";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-menu-generator";
    rev = "2c1eef1a1650df4c65b76d2bc70a26e7d69b6160";
    hash = "sha256-1eW/Y6dcGDBls7mYN7n36qa0msje7DfrctcyjAFiCls=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  doCheck = true;

  strictDeps = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/labwc/labwc-menu-generator";
    description = "Menu generator for labwc";
    mainProgram = "labwc-menu-generator";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ romildo ];
  };
})
