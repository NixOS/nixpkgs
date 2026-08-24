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
  version = "0.2.0-unstable-2026-08-15";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-menu-generator";
    rev = "ae466068ffaea10d10819d993b012da9e27a169a";
    hash = "sha256-mzBgqmpMLq3VTn9gkbEkH3jHMsDBWZ/XnWUFIcOo28s=";
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
