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
  pname = "labwc-tweaks-gtk";
  version = "0-unstable-2024-04-07";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-tweaks-gtk";
    rev = "67adbedd610a1b44e7ba667ae72a5c9b07105119";
    hash = "sha256-RGPm+hvyTWxkd3z841Y8ozXrDD1ZgHCZjimyRdRNrCs=";
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
    homepage = "https://github.com/labwc/labwc-tweaks-gtk";
    description = "Configuration gui app for labwc; gtk fork";
    mainProgram = "labwc-tweaks";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ AndersonTorres romildo ];
  };
})
