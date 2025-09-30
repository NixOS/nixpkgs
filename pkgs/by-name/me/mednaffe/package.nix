{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  gtk3,
  mednafen,
  pkg-config,
  stdenv,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mednaffe";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "AmatCoder";
    repo = "mednaffe";
    rev = finalAttrs.version;
    hash = "sha256-ZizW0EeY/Cc68m87cnbLAkx3G/ULyFT5b6Ku2ObzFRU=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.unix;
  };
})
