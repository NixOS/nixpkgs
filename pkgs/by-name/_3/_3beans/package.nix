{
  lib,
  stdenv,
  fetchFromGitHub,
  libepoxy,
  wxwidgets_3_3,
  wrapGAppsHook3,
  portaudio,
  pkg-config,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "3beans";
  version = "0-unstable-2026-08-05";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Hydr8gon";
    repo = "3Beans";
    rev = "c5ce9ee29635ba229ba40a534842cf6675533bb1";
    hash = "sha256-d+vAfNAPOqV0/9RAca25TIRjHWUYH3gM99AgAPLmpo0=";
  };

  nativeBuildInputs = [
    pkg-config
    wxwidgets_3_3
    wrapGAppsHook3
  ];
  buildInputs = [
    libepoxy
    portaudio
  ];

  makeFlags = [
    "DESTDIR=$(out)"
  ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Low-level 3DS emulator";
    homepage = "https://github.com/Hydr8gon/3Beans";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "3beans";
    maintainers = with lib.maintainers; [ annoyingrains ];
  };
})
