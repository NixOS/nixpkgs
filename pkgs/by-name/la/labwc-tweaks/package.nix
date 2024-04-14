{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gtk3
, libxml2
, xkeyboard_config
, wrapGAppsHook
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc-tweaks";
  version = "unstable-2024-04-02";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-tweaks";
    rev = "a1a3cfaefd1908de8752d0d6d6b7170b04ee075c";
    hash = "sha256-uvUsoqiQBuNMBQWAxl/tCIvWsEYmZ4dQ31TrznI/XcA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    libxml2
  ];

  strictDeps = true;

  postPatch = ''
    substituteInPlace stack-lang.c --replace /usr/share/X11/xkb ${xkeyboard_config}/share/X11/xkb
    substituteInPlace theme.c --replace /usr/share /run/current-system/sw/share
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/labwc/labwc-tweaks";
    description = "Configuration gui app for labwc";
    mainProgram = "labwc-tweaks";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ AndersonTorres romildo ];
  };
})
