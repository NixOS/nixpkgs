{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  gtk3,
}:

stdenv.mkDerivation rec {
  pname = "spotify-tray";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "tsmetana";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-E86rA8cBjy/bI7sZHlT40o7i23PcONXT5GTHEfcaDf0=";
  };

  patches = [
    (fetchpatch {
      name = "fix-building-with-automake-1.16.5.patch";
      url = "https://github.com/tsmetana/spotify-tray/commit/1305f473ba4a406e907b98c8255f23154f349613.patch";
      sha256 = "sha256-u2IopfMzNCu2F06RZoJw3OAsRxxZYdIMnKnyb7/KBgk=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [ gtk3 ];

  meta = with lib; {
    homepage = "https://github.com/tsmetana/spotify-tray";
    description = "Adds a tray icon to the Spotify Linux client application.";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Enzime ];
    mainProgram = "spotify-tray";
  };
}
