{
  lib,
  stdenv,
  copyDesktopItems,
  dart-sass,
  electron,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeDesktopItem,
  makeWrapper,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
}:
let
  pnpm = pnpm_11;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "r2modman";
  version = "3.2.19";

  src = fetchFromGitHub {
    owner = "ebkr";
    repo = "r2modmanPlus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZPwGAoYy3Q69QVgxictibydZPugEMdz4hpx52d7ScCU=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-S32i+QGY6MWw+N9XS4A2K2HRfN1W6Wmf2PfaCfXDwNc=";
  };

  patches = [
    # Make it possible to launch Steam games from r2modman.
    ./steam-launch-fix.patch

    # Fix copying of wrapper files to game directory
    ./wrapper-fix.patch
  ];

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    copyDesktopItems
    dart-sass
    makeWrapper
    nodejs
    pnpm
    pnpmConfigHook
  ];

  # Required, as the build process won't have network access. Uses the wrapped electron binary instead.
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = true;

  postPatch = ''
    # Hide update banner
    echo "<template></template>" > src/components/banner/ManagerUpdateBanner.vue
  '';

  buildPhase = ''
    runHook preBuild

    substituteInPlace node_modules/.pnpm/sass-embedded@*/node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'

    pnpm quasar build --mode electron --skip-pkg

    # Remove unecessary devDependencies only required at build time.
    pnpm prune --prod

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

  passthru.updateScript = ./update.sh;

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
