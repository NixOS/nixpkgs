{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,

  copyDesktopItems,
  makeWrapper,
  makeDesktopItem,

  electron_40,
  nix-update-script,
  nodejs-slim,
  pnpm_10_29_2,
  pnpmConfigHook,
  commandLineArgs ? "",
}:

let
  electron = electron_40;
  pnpm = pnpm_10_29_2;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "any-listen";
  version = "0.7.0-beta.28";

  src = fetchFromGitHub {
    owner = "any-listen";
    repo = "any-listen-desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IGb96chZ9tOMkUOIPbTMoyCDeEsV299paHRmNeW6I8w=";
    fetchSubmodules = true;
  };

  sourceRoot = "source/any-listen";

  patches = [
    # Show the main window explicitly on initial Linux launch. Otherwise it can
    # remain hidden until a second instance calls showWindow().
    ./show-window-after-load.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    sourceRoot = "source/any-listen";
    hash = "sha256-vvkrTNM4sUJ5W9Mrcomkci7U0OZ116RMLju5zYvyBrQ=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    nodejs-slim
    pnpm
    pnpmConfigHook
  ];

  strictDeps = true;

  env = {
    ELECTRON_OVERRIDE_DIST_PATH = "${electron}/libexec/electron";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  postPatch = ''
    # fetchFromGitHub sources do not include a .git directory.
    substituteInPlace packages/desktop/build-config/vite.config.ts \
      --replace-fail "let isClean = !execSync('git status --porcelain').toString().trim()" \
                     "let isClean = false"

    # Disable the built-in automatic updater; updates are handled by Nix.
    substituteInPlace packages/shared/common/defaultSetting.ts \
      --replace-fail "'common.tryAutoUpdate': true" "'common.tryAutoUpdate': false"

    substituteInPlace packages/desktop/src/app/index.ts \
      --replace-fail "if (process.env.NODE_ENV === 'production') void startCheckUpdateTimeout()" \
                     "if (false) void startCheckUpdateTimeout()"

    substituteInPlace packages/desktop/build-config/build-pack.cjs \
      --replace-fail "const options = {" "const options = {
      electronDist: '${electron}/libexec/electron',
      electronVersion: '${electron.version}',"
  '';

  buildPhase = ''
    runHook preBuild

    export ELECTRON_BUILDER_CACHE="$TMPDIR/electron-builder-cache"
    for electronPackage in node_modules/electron packages/desktop/node_modules/electron; do
      if [ -d "$electronPackage" ]; then
        echo "electron" > "$electronPackage/path.txt"
      fi
    done

    pnpm --offline -F @shared/scripts build:desktop:dir

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/opt/${finalAttrs.pname}"
    cp -r build/linux-unpacked/resources "$out/opt/${finalAttrs.pname}/"
    rm -f "$out/opt/${finalAttrs.pname}/resources/app-update.yml"

    makeWrapper ${lib.getExe electron} "$out/bin/any-listen" \
      --inherit-argv0 \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags "$out/opt/${finalAttrs.pname}/resources/app.asar" \
      --add-flags "-dt" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    for icon in packages/desktop/resources/icons/*x*.png; do
      size="''${icon##*/}"
      size="''${size%.png}"
      install -Dm444 "$icon" "$out/share/icons/hicolor/$size/apps/any-listen.png"
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      categories = [
        "AudioVideo"
        "Audio"
        "Player"
        "Music"
      ];
      comment = "Cross-platform private music playback service";
      desktopName = "Any Listen";
      exec = "any-listen %u";
      genericName = "Music Player";
      icon = "any-listen";
      mimeTypes = [ "x-scheme-handler/anylisten" ];
      name = "any-listen";
      startupNotify = false;
      startupWMClass = "any-listen";
      terminal = false;
      type = "Application";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cross-platform private music playback service";
    homepage = "https://github.com/any-listen/any-listen-desktop";
    changelog = "https://github.com/any-listen/any-listen-desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ msdone ];
    mainProgram = "any-listen";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
