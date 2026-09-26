{
  lib,
  fetchFromGitHub,
  stdenv,
  makeBinaryWrapper,
  writableTmpDirAsHomeHook,
  nodejs,
  bun,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "swagger-typescript-api";
  version = "13.13.0";

  src = fetchFromGitHub {
    owner = "acacode";
    repo = "swagger-typescript-api";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lV24rJwgmcTODyvb/qkpKWII4EhKd+xGrs1uwjuSVq4=";
  };

  node_modules = stdenv.mkDerivation {
    inherit (finalAttrs) src version;
    pname = "${finalAttrs.pname}-node_modules";

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    # Skip fixup, would embed store paths or modify binaries,
    # making this fixed-output derivation's output hash unstable.
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
      bun install --no-progress --frozen-lockfile

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';

    outputHash =
      {
        aarch64-darwin = "sha256-BBHQGnSAZ6sgVDX2cTnConqRPjY5umeDHE2lIkvuyo4=";
        aarch64-linux = "sha256-0S9nKVlzv7WQvUXQZ8ZGU+kWhDYP7ciOIUtpdT8ehCA=";
        x86_64-linux = "sha256-vGApFxnG7X9XBZu0z4HpyarNnVFUZk7eq+pQKXS+O5E=";
      }
      .${stdenv.hostPlatform.system}
        or (throw "${finalAttrs.pname}: Platform ${stdenv.hostPlatform.system} is not packaged yet.");

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

    makeBinaryWrapper ${nodejs}/bin/node $out/bin/${finalAttrs.pname} \
      --add-flags $out/lib/dist/cli.cjs \
      --set NODE_ENV production \
      --set NODE_PATH "$out/lib/node_modules"

    runHook postInstall
  '';

  meta = {
    mainProgram = "swagger-typescript-api";
    description = "Generate TypeScript API client and definitions for fetch or axios from an OpenAPI specification";
    homepage = "https://github.com/acacode/swagger-typescript-api";
    changelog = "https://github.com/acacode/swagger-typescript-api/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ angelodlfrtr ];
  };
})
