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
  version = "0.1.0-unstable-2024-07-09";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-menu-generator";
    rev = "a2b3e8e46068d82e97168772e7c194d6b6e03e3d";
    hash = "sha256-Y5gBaTgVu3OzZQwGDNLsmQkfS0txBm/vD0MG5av2Gv0=";
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
