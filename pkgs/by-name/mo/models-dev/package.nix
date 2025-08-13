{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

let
  models-dev-node-modules-hash = {
    "aarch64-darwin" = "sha256-VkqxZF2LkNBoIkbQGz98O+y7LgLqQ+FofV2WyMOOUEs=";
    "aarch64-linux" = "sha256-P7Dik1bXWdipzs4orPff53bDwEXYFHSC05RV789mrTI=";
    "x86_64-darwin" = "sha256-/VdwzrV+srDrexvXHLKtN2Od24XlXVDWu6pEk1zLtjM=";
    "x86_64-linux" = "sha256-hMiCOMskK9kwGKaixsvodUVsOuuageiUAwxp/AvzR44=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "models-dev";
  version = "0-unstable-2025-08-08";
  src = fetchFromGitHub {
    owner = "sst";
    repo = "models.dev";
    rev = "429b76581cd3b63ba5e51be8fd543d4a0ca98f6a";
    hash = "sha256-0A+BGq6+NR78bbCtPDqeG227phLm7/tuompUkdt2+6U=";
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "models-dev-node_modules";
    inherit (finalAttrs) version src;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

       export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

       bun install \
         --force \
         --frozen-lockfile \
         --no-progress

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    # Required else we get errors that our fixed-output derivation references store paths
    dontFixup = true;

    outputHash = models-dev-node-modules-hash.${stdenvNoCC.hostPlatform.system};
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [ bun ];

  patches = [
    # In bun 1.2.13 (release-25.05) HTML entrypoints get content hashes
    # appended → index.html becomes index-pq8vj7za.html in ./dist. So, we
    # rename the index file back to index.html
    ./post-build-rename-index-file.patch
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/node_modules .

    runHook postConfigure
  '';

  preBuild = ''
    patchShebangs packages/web/script/build.ts
  '';

  buildPhase = ''
    runHook preBuild

    cd packages/web
    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/dist
    cp -R ./dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Comprehensive open-source database of AI model specifications, pricing, and capabilities";
    homepage = "https://github.com/sst/models-dev";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ delafthi ];
  };
})
