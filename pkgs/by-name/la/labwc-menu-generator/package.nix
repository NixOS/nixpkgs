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
  version = "0.1.0-unstable-2025-02-12";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-menu-generator";
    rev = "a6e96b496aff6b54bcdaacfcd24720d46d6a683a";
    hash = "sha256-Ju/lH7mZuIsulkQ5lpgfBl9BUs0mAOobS9aBuVlMIqI=";
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
