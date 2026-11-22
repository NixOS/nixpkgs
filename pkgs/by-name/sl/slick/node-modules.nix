{
  lib,
  stdenvNoCC,
  slick,
  bun,
  writableTmpDirAsHomeHook,
}:
stdenvNoCC.mkDerivation {
  pname = "${slick.pname}-node-modules";
  inherit (slick) version src;

  impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
    "GIT_PROXY_COMMAND"
    "SOCKS_SERVER"
  ];

  nativeBuildInputs = [
    bun
    writableTmpDirAsHomeHook
  ];

  dontConfigure = true;
  dontFixup = true;

  buildPhase = ''
    runHook preBuild

    export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

    bun install \
      --cpu="*" \
      --os="*" \
      --force \
      --frozen-lockfile \
      --ignore-scripts \
      --linker=hoisted \
      --no-progress

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R node_modules $out

    runHook postInstall
  '';

  outputHash = "sha256-228TBxvPZBshZ9MbMK4huCMvIJWFk2afypWmUl2U8jM=";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
}
