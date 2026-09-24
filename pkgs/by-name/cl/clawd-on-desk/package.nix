{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  electron_43,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  jq,
  nix-update-script,
}:
let
  electron = electron_43;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "clawd-on-desk";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "rullerzhou-afk";
    repo = "clawd-on-desk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xvmHJmzgEe93YLF+CR4l6u7HYUCEp7bqsRigc+GrZbo=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-d0W0VJzJsxy3s8bp3yULkiYnlfuMnh9+b5WyaSmZvas=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    makeWrapper
    copyDesktopItems
    # koffi is shipped as prebuilt native modules and needs to be patched
    autoPatchelfHook
    jq
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  buildPhase = ''
    runHook preBuild

    # electron builds must be writable
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    # Add the koffi native module to the existing asarUnpack list (instead of
    # overriding it on the electron-builder CLI), since replacing it would
    # drop the hooks/extensions/agents/themes files that need to live
    # outside app.asar to be installed into other tools' config directories.
    jq '.build.asarUnpack += ["**/*.node"]' package.json > package.json.tmp
    mv package.json.tmp package.json

    ./node_modules/.bin/electron-builder \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion="${electron.version}"

    # electron-builder's afterPack hook (scripts/after-pack-koffi.js) prunes
    # the koffi native module down to only the packaged platform's triplet,
    # so only patch it once that has run.
    autoPatchelf ./dist/*-unpacked/resources/app.asar.unpacked/node_modules/koffi

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/clawd-on-desk"
    cp -r ./dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/clawd-on-desk"

    for size in 16 32 48 64 128 256 512; do
      install -Dm644 "assets/icons/''${size}x''${size}.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/clawd-on-desk.png"
    done

    makeWrapper "${lib.getExe electron}" "$out/bin/clawd-on-desk" \
      --add-flags "$out/share/lib/clawd-on-desk/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "clawd-on-desk";
      desktopName = "Clawd on Desk";
      genericName = "Desktop Pet";
      comment = finalAttrs.meta.description;
      exec = "clawd-on-desk %U";
      icon = "clawd-on-desk";
      mimeTypes = [ "x-scheme-handler/clawd" ];
      categories = [ "Utility" ];
      startupWMClass = "Clawd on Desk";
      terminal = false;
    })
  ];

  passthru = {
    inherit (finalAttrs) npmDeps;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Pixel desktop pet that watches Claude Code, Codex, Cursor and other AI coding agents";
    homepage = "https://clawdondesk.com/";
    downloadPage = "https://github.com/rullerzhou-afk/clawd-on-desk";
    changelog = "https://github.com/rullerzhou-afk/clawd-on-desk/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ linuxissuper ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    mainProgram = "clawd-on-desk";
  };
})
