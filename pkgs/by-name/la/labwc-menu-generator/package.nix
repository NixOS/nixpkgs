{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, glib
, pkg-config
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc-menu-generator";
  version = "0.1.0-unstable-2024-09-19";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-menu-generator";
    rev = "ebb8240bfd39ab2ffbe98d5cfe26f9c1b678822d";
    hash = "sha256-4WGBrqY30wVXmnjZ5QPhfNfauvnxqrTE6DFuITfTI4M=";
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
    maintainers = with lib.maintainers; [ AndersonTorres romildo ];
  };
})
