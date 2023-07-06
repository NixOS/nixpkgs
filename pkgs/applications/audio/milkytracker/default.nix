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

  # Requires `ibtool`, but the version in `xib2nib` is not capable of
  # building these apps. Build them using `ibtool` from Xcode, but don't allow any other binaries
  # into the sandbox. Note that the CLT are not supported because `ibtool` requires Xcode.
  sandboxProfile = lib.optionalString stdenv.isDarwin ''
    (allow process-exec
      (literal "/usr/bin/ibtool")
      (regex "/Xcode.app/Contents/Developer/usr/bin/ibtool")
      (regex "/Xcode.app/Contents/Developer/usr/bin/xcodebuild"))
    (allow file-read*)
    (deny file-read* (subpath "/usr/local") (with no-log))
    (allow file-write* (subpath "/private/var/folders"))
  '';

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

  cmakeFlags = [
    # Somehow this does not get set automatically
    "-DSDL2MAIN_LIBRARY=${SDL2}/lib/libSDL2${stdenv.hostPlatform.extensions.sharedLibrary}"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DIBTOOL=/usr/bin/ibtool"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
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
    platforms = platforms.unix;
    maintainers = with maintainers; [ OPNA2608 ];
  };
})
