{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  pkg-config,
  SDL2,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frodo4";
  version = "4.5";

  src = fetchFromGitHub {
    owner = "cebix";
    repo = "frodo4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C9WniyzSGpfs5fZOqqDlFz0je0K5VEpcND5QCaXm9K0=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    SDL2
  ];

  configureScript = "./autogen.sh";

  meta = {
    homepage = "https://github.com/cebix/frodo4";
    description = "C64 emulator with emphasis on graphical accuracy";
    mainProgram = "Frodo";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ chordtoll ];
    platforms = lib.platforms.all;
  };
})
