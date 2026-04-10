{
  lib,
  fetchFromGitHub,
  stdenv,
  python3,
  makeWrapper,
  rsync,
  curlFull,
  wmctrl,
  libxcb-cursor,
  libxkbcommon,
  xwininfo,
  xprop,
  extraPluginDependencies ? [ ],
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "edmarketconnector";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "EDCD";
    repo = "EDMarketConnector";
    tag = "Release/${finalAttrs.version}";
    hash = "sha256-dnSzT1C4ElUkj34S3bYI+v0oKJQQ7zQBZ8OuhVB6ans=";
  };

  nativeBuildInputs = [ makeWrapper ];

  pythonEnv = python3.buildEnv.override {
    extraLibs = [
      python3.pkgs.tkinter
      python3.pkgs.requests
      python3.pkgs.pillow
      (python3.pkgs.watchdog.overrideAttrs {
        disabledTests = [
          "test_select_fd" # Avoid `Too many open files` error. See https://github.com/gorakhargosh/watchdog/issues/1095
        ];
      })
      python3.pkgs.semantic-version
      python3.pkgs.psutil
      python3.pkgs.tomli-w

      # Plugin (from Plugin Browser) dependencies
      # EDMC-BioScan
      python3.pkgs.sqlalchemy

      # EDMCHotkeys
      python3.pkgs.xlib
      python3.pkgs.six
      # KeyD cant run via just the package, to use this plugin set "services.keyd.enable" to true in your NixOS config

      # EDMCModernOverlay
      rsync
      curlFull
      wmctrl
      libxcb-cursor
      libxkbcommon
      xwininfo
      xprop
    ]
    ++ extraPluginDependencies;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons/hicolor/512x512/apps/
    ln -s ${finalAttrs.src}/io.edcd.EDMarketConnector.png $out/share/icons/hicolor/512x512/apps/io.edcd.EDMarketConnector.png

    mkdir -p "$out/share/applications/"
    ln -s "${finalAttrs.src}/io.edcd.EDMarketConnector.desktop" "$out/share/applications/"

    makeWrapper ${finalAttrs.pythonEnv}/bin/python $out/bin/edmarketconnector \
      --add-flags "${finalAttrs.src}/EDMarketConnector.py"

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/EDCD/EDMarketConnector";
    description = "Uploads Elite: Dangerous market data to popular trading tools";
    longDescription = "Downloads commodity market and other station data from the game Elite: Dangerous for use with all popular online and offline trading tools.";
    changelog = "https://github.com/EDCD/EDMarketConnector/releases/tag/Release%2F${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "edmarketconnector";
    maintainers = with lib.maintainers; [
      jiriks74
      toasteruwu
    ];
  };
})
