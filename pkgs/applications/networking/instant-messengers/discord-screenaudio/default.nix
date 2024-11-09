{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, cmake
, pkg-config
, qtbase
, qtwebengine
, qtwayland
, pipewire
, kdePackages
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "discord-screenaudio";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "maltejur";
    repo = "discord-screenaudio";
    rev = "v${version}";
    hash = "sha256-+F+XRBQn4AVDVARdM2XtBDE7c6tMPZTR3cntDL8aenw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    cmake
    pkg-config
  ];

  buildInputs = [
    qtbase
    qtwebengine
    qtwayland
    pipewire
    kdePackages.knotifications
    kdePackages.kxmlgui
    kdePackages.kglobalaccel
  ];

  preConfigure = ''
    # version.cmake either uses git tags or a version.txt file to get app version.
    # Since cmake can't access git tags, write the version to a version.txt ourselves.
    echo "${version}" > version.txt
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Custom discord client that supports streaming with audio on Linux";
    mainProgram = "discord-screenaudio";
    homepage = "https://github.com/maltejur/discord-screenaudio";
    downloadPage = "https://github.com/maltejur/discord-screenaudio/releases";
    changelog = "https://github.com/maltejur/discord-screenaudio/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ huantian ];
    platforms = lib.platforms.linux;
  };
}
