{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  boost,
  httplib,
  openssl,
  nlohmann_json,
  curl,
  makeDesktopItem,
  copyDesktopItems,
  installShellFiles,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "beammp-launcher";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "BeamMP";
    repo = "BeamMP-Launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aAQmgK03a3BY4YWuDyTmJzcePchD74SXfbkHwnaOYW8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    copyDesktopItems
    installShellFiles
  ];

  buildInputs = [
    boost
    httplib
    openssl
    nlohmann_json
    curl
  ];

  desktopItems = [
    (makeDesktopItem {
      name = finalAttrs.pname;
      exec = finalAttrs.meta.mainProgram;
      desktopName = finalAttrs.meta.mainProgram;
      comment = finalAttrs.meta.description;
      categories = [ "Game" ];
      terminal = true;
    })
  ];

  installPhase = ''
    runHook preInstall

    installBin BeamMP-Launcher

    runHook postInstall
  '';

  meta = {
    description = "Launcher for the BeamMP mod for BeamNG.drive";
    homepage = "https://github.com/BeamMP/BeamMP-Launcher";
    mainProgram = "BeamMP-Launcher";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ invertedEcho ];
    platforms = lib.platforms.linux;
  };
})
