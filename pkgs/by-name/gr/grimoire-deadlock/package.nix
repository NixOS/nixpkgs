{
  fetchFromGitHub,
  pnpm_10,
  electron_44,
  stdenv,
  fetchPnpmDeps,
  nodejs_24,
  pnpmConfigHook,
  makeWrapper,
  copyDesktopItems,
  writableTmpDirAsHomeHook,
  python3,
  lib,
  vpkmerge-cli,
  makeDesktopItem,
  p7zip,
  xdg-utils,
  procps,
}:

let
  social-src = fetchFromGitHub {
    owner = "Slush97";
    repo = "grimoire-social";
    rev = "b5811d361450ebe8d863276392ad387a31d8295b";
    hash = "sha256-D69CEBrGshmGTyoYA8d0CYTdTtmY0xIrpFHDnI2vNdY=";
  };
  pnpm = pnpm_10;
  electron = electron_44;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "grimoire-deadlock";
  version = "1.33.0";

  src = fetchFromGitHub {
    owner = "Slush97";
    repo = "grimoire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QA8tDQwgGf7w6dcGaEG2FDHDaF6tHHj0BfsyZftok74=";
  };
  postUnpack = ''
    cp -r ${social-src} "$(dirname "$sourceRoot")/grimoire-social"
    chmod -R u+w "$(dirname "$sourceRoot")/grimoire-social" "$sourceRoot"
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit (finalAttrs) postUnpack;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-AsQv/h9lip586nAx4UqIJZsEGemVR1O8tSqThJB9Muc=";
  };

  nativeBuildInputs = [
    nodejs_24
    pnpm
    pnpmConfigHook
    makeWrapper
    copyDesktopItems
    # electron-builder writes caches under $HOME.
    writableTmpDirAsHomeHook
    # node-gyp for the better-sqlite3 rebuild.
    python3
  ];

  strictDeps = true;

  env = {
    NO_UPDATE_NOTIFIER = "1";
    # prod refuses to run without an https value.
    GRIMOIRE_SOCIAL_BASE_URL = "https://grimoire-social.slusheliott.workers.dev";
  };

  postConfigure = ''
    mkdir -p ../grimoire-social/packages/social-types/node_modules
    ln -s "$PWD/node_modules/zod" ../grimoire-social/packages/social-types/node_modules/zod
  '';

  preBuild = ''
    mkdir -p resources/vpkmerge
    cp ${lib.getExe vpkmerge-cli} resources/vpkmerge/vpkmerge-linux-x86_64
  '';

  buildPhase = ''
    runHook preBuild

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    node_modules/.bin/electron-vite build

    npm_config_nodedir=${electron.headers} npm_config_build_from_source=true \
      node_modules/.bin/electron-builder --dir \
        --config electron-builder.yml \
        --config.electronDist="$PWD/electron-dist" \
        --config.electronVersion=${electron.version} \
        --config.buildDependenciesFromSource=true

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "grimoire";
      desktopName = "Grimoire";
      comment = "Mod manager for Deadlock";
      exec = "grimoire %U";
      icon = "grimoire";
      terminal = false;
      categories = [ "Game" ];
      mimeTypes = [ "x-scheme-handler/grimoire" ];
      startupWMClass = "grimoire";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/grimoire
    cp -r release/linux-unpacked/resources $out/share/grimoire/

    for size in 16 24 32 48 64 128 256 512; do
      install -Dm644 resources/icons/"$size"x"$size".png \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/grimoire.png"
    done

    makeWrapper ${lib.getExe electron} $out/bin/grimoire \
      --inherit-argv0 \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default VPKMERGE_BINARY ${lib.getExe vpkmerge-cli} \
      --set-default USE_SYSTEM_7ZA true \
      --prefix PATH : ${
        lib.makeBinPath [
          p7zip
          xdg-utils
          procps
        ]
      } \
      --add-flags $out/share/grimoire/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}"

    runHook postInstall
  '';

  __structuredAttrs = true;

  passthru = {
    inherit electron;
    inherit (finalAttrs) pnpmDeps;
  };

  meta = {
    description = "Mod manager and companion tool for Deadlock";
    homepage = "https://github.com/Slush97/grimoire";
    changelog = "https://github.com/Slush97/grimoire/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "grimoire";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ justdeeevin ];
  };
})
