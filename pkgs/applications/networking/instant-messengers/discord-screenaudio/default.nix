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
, nix-update-script
}:

stdenv.mkDerivation rec {
  pname = "discord-screenaudio";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "maltejur";
    repo = "discord-screenaudio";
    rev = "v${version}";
    hash = "sha256-it7JSmiDz3k1j+qEZrrNhyAuoixiQuiEbXac7lbJmko=";
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
  ];

  preConfigure = ''
    # version.cmake either uses git tags or a version.txt file to get app version.
    # Since cmake can't access git tags, write the version to a version.txt ourselves.
    echo "${version}" > version.txt
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A custom discord client that supports streaming with audio on Linux";
    homepage = "https://github.com/maltejur/discord-screenaudio";
    downloadPage = "https://github.com/maltejur/discord-screenaudio/releases";
    changelog = "https://github.com/maltejur/discord-screenaudio/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ huantian ];
    platforms = lib.platforms.linux;
  };
}
