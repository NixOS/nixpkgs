{ lib
, fetchFromGitHub
, mkDerivation
, stdenv
, Cocoa
, CoreAudio
, CoreFoundation
, MediaPlayer
, SDL2
, cmake
, libGL
, libX11
, libXrandr
, libvdpau
, mpv
, ninja
, pkg-config
, python3
, qtbase
, qtwayland
, qtwebchannel
, qtwebengine
, qtx11extras
, jellyfin-web
, withDbus ? stdenv.hostPlatform.isLinux
}:

mkDerivation rec {
  pname = "jellyfin-media-player";
  version = "1.11.1";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-media-player";
    rev = "v${version}";
    sha256 = "sha256-Jsn4kWQzUaQI9MpbsLJr6JSJk9ZSnMEcrebQ2DYegSU=";
  };

  patches = [
    # fix the location of the jellyfin-web path
    ./fix-web-path.patch
    # disable update notifications since the end user can't simply download the release artifacts to update
    ./disable-update-notifications.patch
  ];

  buildInputs = [
    SDL2
    libGL
    libX11
    libXrandr
    libvdpau
    mpv
    qtbase
    qtwebchannel
    qtwebengine
    qtx11extras
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    qtwayland
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Cocoa
    CoreAudio
    CoreFoundation
    MediaPlayer
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
  ];

  cmakeFlags = [
    "-DQTROOT=${qtbase}"
    "-GNinja"
  ] ++ lib.optionals (!withDbus) [
    "-DLINUX_X11POWER=ON"
  ];

  preConfigure = ''
    # link the jellyfin-web files to be copied by cmake (see fix-web-path.patch)
    ln -s ${jellyfin-web}/share/jellyfin-web .
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/bin $out/Applications
    mv "$out/Jellyfin Media Player.app" $out/Applications
    ln -s "$out/Applications/Jellyfin Media Player.app/Contents/MacOS/Jellyfin Media Player" $out/bin/jellyfinmediaplayer
  '';

  meta = with lib; {
    homepage = "https://github.com/jellyfin/jellyfin-media-player";
    description = "Jellyfin Desktop Client based on Plex Media Player";
    license = with licenses; [ gpl2Only mit ];
    platforms = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    maintainers = with maintainers; [ jojosch kranzes paumr ];
    mainProgram = "jellyfinmediaplayer";
  };
}
