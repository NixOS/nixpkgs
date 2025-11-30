{
  lib,
  fetchFromGitHub,
  stdenv,
  python3,
  makeWrapper,
}:
let
  pythonEnv = python3.buildEnv.override {
    extraLibs = with python3.pkgs; [
      tkinter
      requests
      pillow
      (watchdog.overrideAttrs {
        disabledTests = [
          "test_select_fd" # Avoid `Too many open files` error. See https://github.com/gorakhargosh/watchdog/issues/1095
        ];
      })
      semantic-version
      psutil
    ];
    ignoreCollisions = true;
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "edmarketconnector";
  version = "5.13.2";

  src = fetchFromGitHub {
    owner = "EDCD";
    repo = "EDMarketConnector";
    tag = "Release/${finalAttrs.version}";
    hash = "sha256-BqzrW5pV9ty1MBaILQir+iOda2xQoJeTq8eZG0x6+90=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/hicolor/512x512/apps/
    ln -s ${finalAttrs.src}/io.edcd.EDMarketConnector.png $out/share/icons/hicolor/512x512/apps/io.edcd.EDMarketConnector.png

    mkdir -p "$out/share/applications/"
    ln -s "${finalAttrs.src}/io.edcd.EDMarketConnector.desktop" "$out/share/applications/"

    makeWrapper ${pythonEnv}/bin/python $out/bin/edmarketconnector \
      --add-flags "${finalAttrs.src}/EDMarketConnector.py"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/EDCD/EDMarketConnector";
    description = "Uploads Elite: Dangerous market data to popular trading tools";
    longDescription = "Downloads commodity market and other station data from the game Elite: Dangerous for use with all popular online and offline trading tools.";
    changelog = "https://github.com/EDCD/EDMarketConnector/releases/tag/Release%2F${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.x86_64;
    mainProgram = "edmarketconnector";
    maintainers = with lib.maintainers; [
      jiriks74
      toasteruwu
    ];
  };
})
