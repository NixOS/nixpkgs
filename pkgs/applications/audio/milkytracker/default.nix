<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, gitUpdater
, alsa-lib
, cmake
, Cocoa
, CoreAudio
, Foundation
, libjack2
, lhasa
, makeWrapper
, perl
, pkg-config
, rtmidi
, SDL2
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

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    lhasa
    libjack2
    perl
    rtmidi
    SDL2
    zlib
    zziplib
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Cocoa
    CoreAudio
    Foundation
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
=======
{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, makeWrapper
, SDL2, alsa-lib, libjack2, lhasa, perl, rtmidi, zlib, zziplib }:

stdenv.mkDerivation rec {
  version = "1.03.00";
  pname = "milkytracker";

  src = fetchFromGitHub {
    owner  = "milkytracker";
    repo   = "MilkyTracker";
    rev    = "v${version}";
    sha256 = "025fj34gq2kmkpwcswcyx7wdxb89vm944dh685zi4bxx0hz16vvk";
  };

  postPatch = ''
    # https://github.com/milkytracker/MilkyTracker/issues/262
    substituteInPlace CMakeLists.txt \
      --replace 'CMAKE_CXX_STANDARD 98' 'CMAKE_CXX_STANDARD 11'
  '';

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];

  buildInputs = [ SDL2 alsa-lib libjack2 lhasa perl rtmidi zlib zziplib ];

  # Somehow this does not get set automatically
  cmakeFlags = [ "-DSDL2MAIN_LIBRARY=${SDL2}/lib/libSDL2.so" ];

  postInstall = ''
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    install -Dm644 $src/resources/milkytracker.desktop $out/share/applications/milkytracker.desktop
    install -Dm644 $src/resources/pictures/carton.png $out/share/pixmaps/milkytracker.png
    install -Dm644 $src/resources/milkytracker.appdata $out/share/appdata/milkytracker.appdata.xml
  '';

<<<<<<< HEAD
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Music tracker application, similar to Fasttracker II";
    homepage = "https://milkytracker.org/";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    platforms = platforms.unix;
    # ibtool -> real Xcode -> I can't get that, and Ofborg can't test that
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [ OPNA2608 ];
  };
})
=======
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
