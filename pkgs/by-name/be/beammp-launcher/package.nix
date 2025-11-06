{
  stdenv,
  fetchFromGitHub,
  lib,
  copyDesktopItems,
  installShellFiles,
  makeDesktopItem,

  cmake,
  curl,
  httplib,
  nlohmann_json,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "beammp-launcher";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "BeamMP";
    repo = "BeamMP-Launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+qdDGOLds2j00BRijFAZ8DMrnjvigs+z+w9+wbitJno=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    copyDesktopItems
    installShellFiles

    cmake
  ];

  buildInputs = [
    curl
    httplib
    nlohmann_json
    openssl
  ];

  desktopItems = [
    (makeDesktopItem {
      categories = [ "Game" ];
      comment = "Launcher for the BeamMP mod for BeamNG.drive";
      desktopName = "BeamMP-Launcher";
      exec = "BeamMP-Launcher";
      name = "BeamMP-Launcher";
      terminal = true;
    })
  ];

  installPhase = ''
    runHook preInstall
    installBin "BeamMP-Launcher"
    copyDesktopItems
    runHook postInstall
  '';

  meta = {
    description = "Launcher for the BeamMP mod for BeamNG.drive";
    homepage = "https://github.com/BeamMP/BeamMP-Launcher";
    license = lib.licenses.agpl3Only;
    mainProgram = "BeamMP-Launcher";
    maintainers = with lib.maintainers; [
      Andy3153
      mochienya
    ];
    platforms = lib.platforms.linux;
  };
})
