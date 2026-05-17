{
  lib,
  fetchFromGitHub,
  stdenv,
  makeBinaryWrapper,
  writableTmpDirAsHomeHook,
  nodejs,
  bun,
}:
let
  pname = "swagger-typescript-api";
  version = "13.9.1";

  node-modules-hash = {
    "x86_64-linux" = "sha256-QxnqTaV5oN5WoYvLzTckWrYAZVAUxTSLYHVTmmqhmgM=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "acacode";
    repo = "swagger-typescript-api";
    rev = "v${version}";
    hash = "sha256-PnQ2aTj8oVUqoqM9voupfBqPu7MZSVflUtuGrXznifo=";
  };

  node_modules = stdenv.mkDerivation {
    inherit (finalAttrs) src version;
    pname = "${pname}-node_modules";

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    # Prevent patchShebangs from rewriting node_modules/.bin shebangs to store
    # paths, which would make this fixed-output derivation's output hash unstable.
    dontPatchShebangs = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --no-progress --frozen-lockfile --no-cache

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    outputHash =
      node-modules-hash.${stdenv.hostPlatform.system}
        or (throw "${finalAttrs.pname}: Platform ${stdenv.hostPlatform.system} is not packaged yet. Supported platforms: x86_64-linux.");
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    bun
  ];

  buildPhase = ''
    runHook preBuild

    cp -R ${finalAttrs.node_modules}/node_modules .
    patchShebangs node_modules

    bun run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r {dist,templates,node_modules} $out/lib

    makeBinaryWrapper ${nodejs}/bin/node $out/bin/${pname} \
      --add-flags $out/lib/dist/cli.cjs \
      --set NODE_ENV production \
      --set NODE_PATH "$out/lib/node_modules"

    runHook postInstall
  '';

  meta = {
    mainProgram = "swagger-typescript-api";
    description = "Generate TypeScript API client and definitions for fetch or axios from an OpenAPI specification";
    homepage = "https://github.com/acacode/swagger-typescript-api";
    changelog = "https://github.com/acacode/swagger-typescript-api/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ angelodlfrtr ];
  };
})
