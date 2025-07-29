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
    "aarch64-darwin" = "sha256-2EVW5zQTcqH9zBYAegWj/Wtb0lYHZwA7Bbqs3gRjcx0=";
    "aarch64-linux" = "sha256-nJgFnszwvknqA21uaqlGQQ1x+4ztKx0/tEvcNrv1LJg=";
    "x86_64-darwin" = "sha256-Un6UxmvsmBuDdUwcWnu4qb0nPN1V1PFJi4VGVkNh/YU=";
    "x86_64-linux" = "sha256-nlL+Ayacxz4fm404cABORSVGQcNxb3cB4mOezkrI90U=";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "models-dev";
  version = "0-unstable-2025-07-29";
  src = fetchFromGitHub {
    owner = "sst";
    repo = "models.dev";
    rev = "69e91b1cee1dbd737dc60f5f99ce123a81763cda";
    hash = "sha256-fr4cgQsW03ukgCxNBtlokAXmqjGh1fFJucWx1dJ7xV0=";
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
