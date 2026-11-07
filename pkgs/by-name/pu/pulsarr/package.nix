{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bun,
  nodejs,
  makeWrapper,
  writableTmpDirAsHomeHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "pulsarr";
  version = "0.19.7";

  src = fetchFromGitHub {
    owner = "jamcalli";
    repo = "Pulsarr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W/Sn3ehb+XYXGAg10aZxf+X9YQgeB0x73UKbdC2lhpw=";
  };

  nativeBuildInputs = [
    bun
    nodejs
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  __structuredAttrs = true;
  strictDeps = true;

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.passthru.node_modules}/node_modules .
    chmod -R u+w node_modules
    patchShebangs --build node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/pulsarr
    cp -R dist migrations packages package.json $out/lib/pulsarr/
    cp -R ${finalAttrs.passthru.node_modules}/production/node_modules $out/lib/pulsarr/
    install -Dm644 .env.example $out/share/pulsarr/.env.example
    makeWrapper ${lib.getExe bun} $out/bin/pulsarr \
      --run 'export dataDir="''${dataDir:-${
        if stdenvNoCC.hostPlatform.isDarwin then "$HOME/.config/Pulsarr" else "$PWD/data"
      }}"' \
      --chdir "$out/lib/pulsarr" \
      --run '${lib.getExe bun} run --bun migrations/migrate.ts' \
      --add-flags 'run --bun dist/server.js'

    runHook postInstall
  '';

  passthru.node_modules = stdenvNoCC.mkDerivation {
    pname = "${finalAttrs.pname}-node_modules";
    inherit (finalAttrs) version src;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    __structuredAttrs = true;
    strictDeps = true;
    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --frozen-lockfile --ignore-scripts --no-progress --cpu="*" --os="*"

      mkdir production
      cp package.json bun.lock production/
      cp -R packages production/
      bun install --cwd production --production --frozen-lockfile --ignore-scripts --no-progress --omit=peer --cpu="*" --os="*"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/production
      cp -R node_modules $out/
      cp -R production/node_modules $out/production/

      runHook postInstall
    '';

    outputHash = "sha256-1i8p+LomLbw0yUBUxbPu7e0ZZZTKkTLj0ruDP79V/d8=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  meta = {
    description = "Plex watchlist tracker and notification center for the Arr stack";
    homepage = "https://jamcalli.github.io/Pulsarr/";
    changelog = "https://github.com/jamcalli/Pulsarr/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.jblik ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "pulsarr";
  };
})
