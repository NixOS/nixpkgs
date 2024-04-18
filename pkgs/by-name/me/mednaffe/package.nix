{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  gtk3,
  mednafen,
  pkg-config,
  stdenv,
  wrapGAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mednaffe";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "AmatCoder";
    repo = "mednaffe";
    rev = finalAttrs.version;
    hash = "sha256-zvSAt6CMcgdoPpTTA5sPlQaWUw9LUMsR2Xg9jM2UaWY=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
    mednafen
  ];

  enableParallelBuilding = true;

  strictDeps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH ':' "${mednafen}/bin"
    )
   '';

  meta = {
    description = "GTK-based frontend for mednafen emulator";
    mainProgram = "mednaffe";
    homepage = "https://github.com/AmatCoder/mednaffe";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
