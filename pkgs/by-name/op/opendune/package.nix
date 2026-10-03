{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  libpulseaudio,
  SDL2,
  SDL2_image,
  SDL2_mixer,
}:

# - set the opendune configuration at ~/.config/opendune/opendune.ini:
#     [opendune]
#     datadir=/path/to/opendune-data
# - download dune2 into [datadir] http://www.bestoldgames.net/eng/old-games/dune-2.php

stdenv.mkDerivation (finalAttrs: {
  pname = "opendune";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "OpenDUNE";
    repo = "OpenDUNE";
    rev = finalAttrs.version;
    hash = "sha256-Z1zEbiqx3QQkoYwfeZnoY+lIqElm1QY0Wm349rXNO5c=";
  };

  postPatch = ''
    substituteInPlace include/types.h \
      --replace-fail "typedef unsigned char bool;" ""
  '';

  configureFlags = [
    "--with-alsa=${lib.getLib alsa-lib}/lib/libasound.so"
    "--with-pulse=${lib.getLib libpulseaudio}/lib/libpulse.so"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    libpulseaudio
    SDL2
    SDL2_image
    SDL2_mixer
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin bin/opendune
    install -Dm444 -t $out/share/doc/opendune enhancement.txt README.txt

    runHook postInstall
  '';

  meta = {
    description = "Dune, Reinvented";
    mainProgram = "opendune";
    homepage = "https://github.com/OpenDUNE/OpenDUNE";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
})
