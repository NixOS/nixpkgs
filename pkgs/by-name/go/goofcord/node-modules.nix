# fixed output derivation for node_modules
{
  lib,
  stdenv,
  goofcord,
  bun,
  nodejs,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation {
  inherit (goofcord) version src;
  pname = goofcord.pname + "-modules";

  impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
    "GIT_PROXY_COMMAND"
    "SOCKS_SERVER"
  ];

  nativeBuildInputs = [
    bun
    nodejs
    writableTmpDirAsHomeHook
  ];

  dontConfigure = true;
  dontFixup = true;

  buildPhase = ''
    runHook preBuild

    export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
    export npm_config_build_from_source=true
    export ELECTRON_SKIP_BINARY_DOWNLOAD=1

    bun install \
      --frozen-lockfile \
      --linker=hoisted \
      --no-progress

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R ./node_modules $out

    runHook postInstall
  '';

  outputHash =
    {
      x86_64-linux = "sha256-NjZw+B/Ml5tZAiegqsxyxzM4H/UL/Dlkl1GyO3hchEU=";
      aarch64-linux = "sha256-+i1d+ii4KUxNT/R1jfr2ttg7R52e4t9N1r44vlGegz4=";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
}
