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
  version = "unstable-2024-04-08";

  src = fetchFromGitHub {
    owner = "labwc";
    repo = "labwc-tweaks";
    rev = "0983b0fdb5865e7593bb8d06acb828fbc2a68cda";
    hash = "sha256-u/Wbl7G0QY4DzHBNYSUln/V77+GiFZ4DaiGmT5H5/6o=";
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
