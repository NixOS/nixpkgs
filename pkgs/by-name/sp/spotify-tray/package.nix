{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, gtk3 }:

stdenv.mkDerivation {
  pname = "spotify-tray";
  version = "1.3.2-unstable-2024-02-10";

  src = fetchFromGitHub {
    owner = "tsmetana";
    repo = "spotify-tray";
    rev = "faf3a72a695c5271361af13f44a65ac3ee481697";
    hash = "sha256-OX8RUmJedPMJFOGhnfOKkHDU9P34XCQCvzd/MPwi52M=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ gtk3 ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/tsmetana/spotify-tray";
    description = "Adds a tray icon to the Spotify Linux client application.";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Enzime ];
    mainProgram = "spotify-tray";
  };
}
