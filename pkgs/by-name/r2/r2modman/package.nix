{
  lib,
  stdenv,
  yarn,
  dart-sass,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  electron,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "r2modman";
  version = "3.2.9";

  src = fetchFromGitHub {
    owner = "ebkr";
    repo = "r2modmanPlus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rnW8itUsP2a09gQU3IXZI7kSVKIxxCgbt15NoH/g0a8=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-V6N0RIjT3etoP6XdZhnQv4XViLRypp/JWxnb0sBc6Oo=";
  };

  patches = [
    # Make it possible to launch Steam games from r2modman.
    ./steam-launch-fix.patch
  ];

  nativeBuildInputs = [
    yarn
    dart-sass
    fixup-yarn-lock
    nodejs
    makeWrapper
    copyDesktopItems
  ];

  configurePhase = ''
    runHook preConfigure

    # Workaround for webpack bug
    # https://github.com/webpack/webpack/issues/14532
    export NODE_OPTIONS="--openssl-legacy-provider"
    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror $offlineCache
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline quasar build --mode electron --skip-pkg

    # Remove dev dependencies.
    yarn install --production --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive

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
    ];
    inherit (electron.meta) platforms;
  };
})
