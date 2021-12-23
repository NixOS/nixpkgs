{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, gtk3 }:

stdenv.mkDerivation rec {
  pname = "spotify-tray";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "tsmetana";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-E86rA8cBjy/bI7sZHlT40o7i23PcONXT5GTHEfcaDf0=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ gtk3 ];

  meta = with lib; {
    homepage = "https://github.com/tsmetana/spotify-tray";
    description = "Adds a tray icon to the Spotify Linux client application.";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Enzime ];
  };
}
