{
  buildNpmPackage,
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  unstableGitUpdater,
  writeScriptBin,
  electronAppName ? "Antimatter Dimensions",
}:

let
  # build doesn't provide app.js, only index.html as entry point.
  # app.js is used to change the directory where data is stored
  # instead of default Electron. This workaround will be removed
  # when this file will be available in upstream repository.
  dummyElectronApp = ./app.js;
in
buildNpmPackage rec {
  pname = "antimatter-dimensions";
  version = "0-unstable-2025-09-17";
  src = fetchFromGitHub {
    owner = "IvarK";
    repo = "AntimatterDimensionsSourceCode";
    rev = "8b5a34c1211df7cb35969dc8e5d402b0b28b7589";
    hash = "sha256-ptyLpGtHHhsPBS//LpuO327uXPqQWTs1DLGjcsrvZtw=";
  };
  nativeBuildInputs = [
    copyDesktopItems
    # build script calls git to get git hash, message and author
    # since fetchFromGitHub doesn't provide this information
    # and in order to keep determinism (#8567), create a dummy git
    (writeScriptBin "git" ''
      echo "unknown"
    '')
  ];

  npmDepsHash = "sha256-aG+oysgitQvdFM0QyzJ3DBxsanBHYI+UPJPhj6bf00Q=";
  npmFlags = [ "--legacy-peer-deps" ];
  npmBuildScript = "build:release";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/antimatter-dimensions
    cp -Tr dist $out/share/antimatter-dimensions
    mkdir -p $out/share/icons/hicolor/256x256/apps
    ln -rs $out/share/antimatter-dimensions/icon.png $out/share/icons/hicolor/256x256/apps/antimatter-dimensions.png
    cp ${dummyElectronApp} $out/share/antimatter-dimensions/app.js

    makeWrapper ${lib.getExe electron} $out/bin/antimatter-dimensions \
      --add-flags $out/share/antimatter-dimensions/app.js \
      --set ELECTRON_APP_NAME "${electronAppName}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "antimatter-dimensions";
      exec = "antimatter-dimensions";
      icon = "antimatter-dimensions";
      desktopName = electronAppName;
      comment = meta.description;
      categories = [ "Game" ];
      terminal = false;
    })
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    homepage = "https://github.com/IvarK/AntimatterDimensionsSourceCode";
    description = "Idle incremental game with multiple prestige layers";
    license = lib.licenses.mit;
    mainProgram = "antimatter-dimensions";
    maintainers = with lib.maintainers; [ amozeo ];
    inherit (electron.meta) platforms;
  };
}
