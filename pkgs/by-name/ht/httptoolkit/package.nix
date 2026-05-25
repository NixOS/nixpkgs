{
  lib,
  stdenv,

  buildNpmPackage,
  fetchFromGitHub,
  makeDesktopItem,

  copyDesktopItems,
  makeWrapper,
  xcbuild,

  electron_41,
  httptoolkit-server,
}:

let
  electron = electron_41;
in
buildNpmPackage rec {
  pname = "httptoolkit";

  # update together with httptoolkit-server
  # nixpkgs-update: no auto update
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "httptoolkit";
    repo = "httptoolkit-desktop";
    tag = "v${version}";
    hash = "sha256-WEl0DGYdq1qa5zNEVO6L8TW6lgNTI0NdL0YXeR3Z0BI=";
  };

  patches = [
    ./fix-paths.patch
  ];

  postPatch = ''
    substituteInPlace httptoolkit-{mcp,ctl} src/index.ts \
      --replace-fail "@out@" "$out"
  '';

  npmDepsHash = "sha256-fGVxHhJU/1ZsRyX3AnP6jM/jkY0PZHKDA1tb2z06lLs=";

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ copyDesktopItems ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ xcbuild ];

  npmBuildScript = "build:src";

  postBuild = ''
    cp -rL ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.mac.forceCodeSigning=false \
      -c.mac.identity=null
    # ^ this disables codesigning on Darwin
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/httptoolkit
    cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/httptoolkit

    ln -s ${httptoolkit-server} $out/share/httptoolkit/resources/httptoolkit-server

    install -Dm644 src/icons/icon.svg $out/share/icons/hicolor/scalable/apps/httptoolkit.svg

    makeWrapper ${lib.getExe electron} $out/bin/httptoolkit \
      --add-flags $out/share/httptoolkit/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r dist/mac*/"HTTP Toolkit.app" $out/Applications

    ln -s ${httptoolkit-server} "$out/Applications/HTTP Toolkit.app/Contents/Resources/httptoolkit-server"

    makeWrapper "$out/Applications/HTTP Toolkit.app/Contents/MacOS/HTTP Toolkit" $out/bin/httptoolkit
  ''
  + ''
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
    platforms = electron.meta.platforms;
  };
}
