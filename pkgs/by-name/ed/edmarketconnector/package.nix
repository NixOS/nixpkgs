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
          "test_select_fd"
        ];
      })
      semantic-version
      psutil
    ];
    ignoreCollisions = true;
  };
in
stdenv.mkDerivation rec {
  pname = "edmarketconnector";
  version = "5.12.5";

  src = fetchFromGitHub {
    owner = "EDCD";
    repo = "EDMarketConnector";
    tag = "Release/${version}";
    hash = "sha256-pcdm3eWMVi+3cYXRcNjU2vYJpj8f0YS3GT0sFGSFYb4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstallPhase

    install -Dm644 ${src}/io.edcd.EDMarketConnector.png $out/share/icons/hicolor/512x512/apps/io.edcd.EDMarketConnector.png

    mkdir -p "$out/share/applications/"
    cp "$src/io.edcd.EDMarketConnector.desktop" "$out/share/applications/"

    substituteInPlace "$out/share/applications/io.edcd.EDMarketConnector.desktop" \
      --replace-fail 'edmarketconnector' "$out/bin/edmarketconnector"

    makeWrapper ${pythonEnv}/bin/python $out/bin/edmarketconnector \
      --add-flags "${src}/EDMarketConnector.py $@"

    runHook postInstallPhase
  '';

  meta = {
    homepage = "https://github.com/EDCD/EDMarketConnector";
    description = "Uploads Elite: Dangerous market data to popular trading tools";
    longDescription = "Downloads commodity market and other station data from the game Elite: Dangerous for use with all popular online and offline trading tools.";
    changelog = "https://github.com/EDCD/EDMarketConnector/releases/tag/Release%2F${version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.x86_64;
    mainProgram = "edmarketconnector";
    maintainers = with lib.maintainers; [ jiriks74 ];
  };
}
