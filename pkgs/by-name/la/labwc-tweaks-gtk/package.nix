{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, gtk3
, libxml2
, xkeyboard_config
, wrapGAppsHook3
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc-tweaks-gtk";
  version = "0-unstable-2024-09-30";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-tweaks-gtk";
    rev = "19ae222b6bab778d0f8a900d39c25ab020e33631";
    hash = "sha256-coA8gU2AKeHs6OENxBWholk5sEL/oketxNFLd8M1kTM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
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
    mainProgram = "labwc-tweaks-gtk";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ AndersonTorres romildo ];
  };
})
