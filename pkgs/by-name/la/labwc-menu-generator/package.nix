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
  version = "0.2.0-unstable-2026-08-21";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-menu-generator";
    rev = "b31ae37532d77e638e27e8a3f3a4865ca5ccab71";
    hash = "sha256-iKaHQdpYGG0gk9uWh2NPFhn/LEw6Bu1tgbvVqGZdWNA=";
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
