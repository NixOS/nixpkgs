{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, gitUpdater
, cmake
, pkg-config
, makeWrapper
, SDL2
, alsa-lib
, libjack2
, lhasa
, perl
, rtmidi
, zlib
, zziplib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "milkytracker";
  version = "1.04.00";

  src = fetchFromGitHub {
    owner = "milkytracker";
    repo = "MilkyTracker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ta4eV/FGBfgTppJwDam0OKQ7udtlinbWly/FPCE+Qss=";
  };

  patches = [
    # Fix crash after querying midi ports
    # Remove when version > 1.04.00
    (fetchpatch {
      url = "https://github.com/milkytracker/MilkyTracker/commit/7e9171488fc47ad2de646a4536794fda21e7303d.patch";
      hash = "sha256-CmnIwmGGnsnlRrvVAXe2zaQf1CFMB5BJPKmiwGOHgGY=";
    })
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    lhasa
    libjack2
    perl
    rtmidi
    SDL2
    zlib
    zziplib
  ];

  cmakeFlags = [
    # Somehow this does not get set automatically
    "-DSDL2MAIN_LIBRARY=${SDL2}/lib/libSDL2.so"
  ];

  postInstall = ''
    install -Dm644 $src/resources/milkytracker.desktop $out/share/applications/milkytracker.desktop
    install -Dm644 $src/resources/pictures/carton.png $out/share/pixmaps/milkytracker.png
    install -Dm644 $src/resources/milkytracker.appdata $out/share/appdata/milkytracker.appdata.xml
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Music tracker application, similar to Fasttracker II";
    homepage = "https://milkytracker.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ OPNA2608 ];
  };
})
