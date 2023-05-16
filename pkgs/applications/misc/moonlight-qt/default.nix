{ stdenv
, lib
, fetchFromGitHub
, wrapQtAppsHook
, pkg-config
, qmake
, qtquickcontrols2
, SDL2
, SDL2_ttf
, libva
, libvdpau
, libxkbcommon
, alsa-lib
, libpulseaudio
, openssl
, libopus
, ffmpeg
, wayland
<<<<<<< HEAD
, darwin
}:

let
  inherit (darwin.apple_sdk_11_0.frameworks) AVFoundation AppKit AudioUnit VideoToolbox;
in

=======
}:

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
stdenv.mkDerivation rec {
  pname = "moonlight-qt";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "moonlight-stream";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Utpv9VdX5vuUWDSGc3YcF8tHbvUZpPeXEDP4NKts+vI=";
    fetchSubmodules = true;
  };

<<<<<<< HEAD
  patches = [ ./darwin.diff ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    wrapQtAppsHook
    pkg-config
    qmake
  ];

  buildInputs = [
    qtquickcontrols2
    SDL2
    SDL2_ttf
<<<<<<< HEAD
    openssl
    libopus
    ffmpeg
  ] ++ lib.optionals stdenv.isLinux [
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    libva
    libvdpau
    libxkbcommon
    alsa-lib
    libpulseaudio
<<<<<<< HEAD
    wayland
  ] ++ lib.optionals stdenv.isDarwin [
    AVFoundation
    AppKit
    AudioUnit
    VideoToolbox
  ];

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir $out/Applications $out/bin
    mv app/Moonlight.app $out/Applications
    rm -r $out/Applications/Moonlight.app/Contents/Frameworks
    ln -s $out/Applications/Moonlight.app/Contents/MacOS/Moonlight $out/bin/moonlight
  '';

=======
    openssl
    libopus
    ffmpeg
    wayland
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Play your PC games on almost any device";
    homepage = "https://moonlight-stream.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
    mainProgram = "moonlight";
  };
}
