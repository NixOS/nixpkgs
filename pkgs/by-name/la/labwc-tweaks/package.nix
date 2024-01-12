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
  version = "unstable-2024-01-04";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-tweaks";
    rev = "1604f64cc62e4800ee04a6e1c323a48ee8140d83";
    hash = "sha256-xFvc+Y03HjSvj846o84Wpk5tEXI49z8xkILSX2oas8A=";
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
