{
  lib,
  stdenv,
  copyDesktopItems,
  dart-sass,
  electron,
  fetchFromGitHub,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
  nodejs,
  yarn-berry,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "r2modman";
  version = "3.2.14";

  src = fetchFromGitHub {
    owner = "ebkr";
    repo = "r2modmanPlus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iB4qUFiXFT+n9lczA1kvMW/IHRuB0H44fg43v//AzKA=";
  };

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src patches missingHashes;
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-5XTkUa31D83oZRZBQ9yUDjgf/4gWCDd+pr4FTNDW9F0=";
  };

  patches = [
    # Make it possible to launch Steam games from r2modman.
    ./steam-launch-fix.patch
  ];

  nativeBuildInputs = [
    copyDesktopItems
    dart-sass
    makeWrapper
    nodejs
    yarn-berry
    yarn-berry.yarnBerryConfigHook
  ];

  env = {
    # Required, as the build process won't have network access. Uses the wrapped electron binary instead.
    ELECTRON_SKIP_BINARY_DOWNLOAD = true;
  };

  buildPhase = ''
    runHook preBuild

    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'

    yarn quasar build --mode electron --skip-pkg

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/r2modman
    cp -r dist/electron/UnPackaged/. node_modules $out/share/r2modman

    (
      cd public/icons
      for img in *png; do
        dimensions=''${img#favicon-}
        dimensions=''${dimensions%.png}
        mkdir -p $out/share/icons/hicolor/$dimensions/apps
        cp $img $out/share/icons/hicolor/$dimensions/apps/r2modman.png
      done
    )

    makeWrapper '${lib.getExe electron}' "$out/bin/r2modman" \
      --inherit-argv0 \
      --add-flags "$out/share/r2modman" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "r2modman";
      exec = "r2modman %U";
      icon = "r2modman";
      desktopName = "r2modman";
      comment = finalAttrs.meta.description;
      categories = [ "Game" ];
      mimeTypes = [ "x-scheme-handler/ror2mm" ];
      keywords = [
        "launcher"
        "mod manager"
        "thunderstore"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/ebkr/r2modmanPlus/releases/tag/v${finalAttrs.version}";
    description = "Unofficial Thunderstore mod manager";
    homepage = "https://github.com/ebkr/r2modmanPlus";
    license = lib.licenses.mit;
    mainProgram = "r2modman";
    maintainers = with lib.maintainers; [
      huantian
      hythera
    ];
    inherit (electron.meta) platforms;
  };
})
