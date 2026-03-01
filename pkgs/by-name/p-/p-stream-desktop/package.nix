{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  electron_39,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  python3,
}:

let
  electron = electron_39;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "p-stream-desktop";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "p-stream";
    repo = "p-stream-desktop";
    rev = "${finalAttrs.version}";
    hash = "sha256-roRmNIaaCoYdmuNBkk3ItVTy/edmIoqqCrVAsHKxBSg=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_10;
    fetcherVersion = 2;
    hash = "sha256-XJiJu6/B4ZoQTmD8iFzehuiaws0ZId5v/OXk3IpMopw=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
    copyDesktopItems
    makeWrapper
    python3
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_nodedir = electron.headers;
  };

  postPatch = ''
    rm -f pnpm-workspace.yaml
  '';

  buildPhase = ''
    runHook preBuild

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pnpm exec electron-builder --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.buildDependenciesFromSource=false

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/p-stream-desktop
    cp -r dist/*-unpacked/resources $out/opt/p-stream-desktop/

    for file in build/icon_*x32.png; do
      file_suffix=''${file//build\/icon_}
      install -Dm0644 $file $out/share/icons/hicolor/''${file_suffix//x32.png}/apps/p-stream-desktop.png
    done

    makeWrapper ${electron}/bin/electron $out/bin/p-stream-desktop \
      --add-flags $out/opt/p-stream-desktop/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "p-stream-desktop";
      desktopName = "P-Stream";
      exec = "p-stream-desktop %U";
      icon = "p-stream-desktop";
      startupWMClass = "P-Stream";
      genericName = "Media Streaming";
      categories = [
        "AudioVideo"
        "Video"
        "Player"
        "Network"
      ];
    })
  ];

  passthru = {
    inherit (finalAttrs) pnpmDeps;
  };

  meta = {
    description = "Desktop app for P-Stream with enhanced streaming capabilities";
    homepage = "https://pstream.mov/";
    changelog = "https://github.com/p-stream/p-stream-desktop/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "p-stream-desktop";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ lib.maintainers.nullstring1 ];
  };
})
