{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  electron,
  httptoolkit-server,
}:

let
  electronDist = electron + (if stdenv.isDarwin then "/Applications" else "/libexec/electron");
in
buildNpmPackage rec {
  pname = "httptoolkit";
  version = "1.17.2";

  src = fetchFromGitHub {
    owner = "httptoolkit";
    repo = "httptoolkit-desktop";
    rev = "v${version}";
    hash = "sha256-TNFl2ADSyUCsBBHsk4nR+h9nRmz9TpM5XOp00Zk504Q=";
  };

  npmDepsHash = "sha256-hO1tzWs1J8Z6Zvsm6ajBt/oZwzNPYu33UNfBaVLA3kY=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # disable code signing on Darwin
  env.CSC_IDENTITY_AUTO_DISCOVERY = "false";

  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals (!stdenv.isDarwin) [ copyDesktopItems ];

  npmBuildScript = "build:src";

  postBuild = ''
    cp -r ${electronDist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
        --dir \
        -c.electronDist=electron-dist \
        -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString (!stdenv.isDarwin) ''
      mkdir -p $out/share/httptoolkit
      cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/httptoolkit

      ln -s ${httptoolkit-server} $out/share/httptoolkit/resources/httptoolkit-server

      install -Dm644 src/icons/icon.svg $out/share/icons/hicolor/scalable/apps/httptoolkit.svg

      makeWrapper ${lib.getExe electron} $out/bin/httptoolkit \
          --add-flags $out/share/httptoolkit/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
          --inherit-argv0
    ''}

    ${lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/Applications
      cp -r dist/mac*/"HTTP Toolkit.app" $out/Applications

      ln -s ${httptoolkit-server} "$out/Applications/HTTP Toolkit.app/Contents/Resources/httptoolkit-server"

      makeWrapper "$out/Applications/HTTP Toolkit.app/Contents/MacOS/HTTP Toolkit" $out/bin/httptoolkit
    ''}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "httptoolkit";
      desktopName = "HTTP Toolkit";
      exec = "httptoolkit %U";
      terminal = false;
      icon = "httptoolkit";
      startupWMClass = "HTTP Toolkit";
      comment = meta.description;
      categories = [ "Development" ];
      startupNotify = true;
    })
  ];

  meta = {
    description = "HTTP(S) debugging, development & testing tool";
    homepage = "https://httptoolkit.com/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "httptoolkit";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
