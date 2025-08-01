{
  stdenv,
  lib,
  fetchzip,
  wxGTK32,
  coreutils,
  SDL2,
  openal,
  alsa-lib,
  pkg-config,
  gtk3,
  wrapGAppsHook3,
  autoreconfHook,
  withNetworking ? true,
  withALSA ? true,
}:

stdenv.mkDerivation rec {
  pname = "pcem";
  version = "17";

  src = fetchzip {
    url = "https://pcem-emulator.co.uk/files/PCemV${version}Linux.tar.gz";
    stripRoot = false;
    sha256 = "067pbnc15h6a4pnnym82klr1w8qwfm6p0pkx93gx06wvwqsxvbdv";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    wrapGAppsHook3
  ];
  buildInputs = [
    wxGTK32
    coreutils
    SDL2
    openal
    gtk3
  ]
  ++ lib.optional withALSA alsa-lib;

  configureFlags = [
    "--enable-release-build"
  ]
  ++ lib.optional withNetworking "--enable-networking"
  ++ lib.optional withALSA "--enable-alsa";

  # Fix GCC 14 build
  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types";

  meta = with lib; {
    description = "Emulator for IBM PC computers and clones";
    mainProgram = "pcem";
    homepage = "https://pcem-emulator.co.uk/";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.terin ];
    platforms = platforms.linux ++ platforms.windows;
  };
}
