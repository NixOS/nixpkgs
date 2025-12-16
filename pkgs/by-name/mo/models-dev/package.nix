{
  lib,
  stdenvNoCC,
  bun,
  fetchgit,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
let
  pname = "models-dev";
  version = "0-unstable-2025-12-11";
  src = fetchFromGitHub {
    owner = "sst";
    repo = "models.dev";
    rev = "0c66fc84a2deb49500b9bb67e37d87428f544119";
    hash = "sha256-HAGUVpdW0gLXCo3jCU7pnjvh1cTp8xnU59MXgCwQkGs=";
  };

  node_modules = stdenvNoCC.mkDerivation {
    pname = "${pname}-node_modules";
    inherit version src;

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
         --filter=./packages/web \
         --force \
         --frozen-lockfile \
         --ignore-scripts \
         --no-progress \
         --production

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      find . -type d -name node_modules -exec cp -R --parents {} $out \;

      runHook postInstall
    '';

    # NOTE: Required else we get errors that our fixed-output derivation references store paths
    dontFixup = true;

    outputHash = "sha256-E6QV2ruzEmglBZaQMKtAdKdVpxOiwDX7bMQM8jRsiqs=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    src
    node_modules
    ;

  nativeBuildInputs = [ bun ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${node_modules}/. .

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    cd packages/web
    bun run ./script/build.ts

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/dist
    cp -R ./dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version=branch"
      "--subpackage"
      "node_modules"
    ];
  };

  meta = {
    description = "Comprehensive open-source database of AI model specifications, pricing, and capabilities";
    homepage = "https://github.com/sst/models-dev";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ delafthi ];
  };
})
