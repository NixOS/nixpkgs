{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gtk3,
  libxml2,
  xkeyboard_config,
  wrapGAppsHook3,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "labwc-tweaks-gtk";
  version = "0-unstable-2026-03-02";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-tweaks-gtk";
    rev = "ebdabbb818703bcd7906e95682855fd63539b8cf";
    hash = "sha256-R9f4Wupy6WHB6Tl4ep+wHuyRjO0zJLAc4ScYQinzwe0=";
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
    maintainers = with lib.maintainers; [ romildo ];
  };
})
