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
    "aarch64-darwin" = "sha256-099Y+7cLtSQ0s71vxUGEochQSpCv1hbkwYbWx/eOvhY=";
    "aarch64-linux" = "sha256-fOmp7UyszqpR04f5TW0pU96IO7euaxX9fBMtwoqIMY4=";
    "x86_64-darwin" = "sha256-OsJDPCsEAAcXzgI/QrtfXXb2jc82pp6ldHuA4Ps8OpM=";
    "x86_64-linux" = "sha256-Enx27ag7D0Qeb/ss/7zTQ1XSukyPzOMMK7pTYHqQUMs=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "models-dev";
  version = "0-unstable-2025-08-01";
  src = fetchFromGitHub {
    owner = "sst";
    repo = "models.dev";
    rev = "2e3f718c40e8868c2487b7275131b2e054feb462";
    hash = "sha256-P7Q03I68ih2eKNfPkpzkIuvKcHLsrk8yxWbFCw74Pjg=";
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
