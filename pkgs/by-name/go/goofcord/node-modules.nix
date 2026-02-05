# fixed output derivation for node_modules
{
  lib,
  stdenvNoCC,
  goofcord,
  bun,
  writableTmpDirAsHomeHook,
}:
stdenvNoCC.mkDerivation {
  inherit (goofcord) version src;
  pname = goofcord.pname + "-modules";

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
      --frozen-lockfile \
      --ignore-scripts \
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
      x86_64-linux = "sha256-rSK+YiVwc2BPqOIS4U0nZ/iI7GuBv1LNhWqbEPBSA9s=";
      aarch64-linux = "sha256-v7b9ww3LML50dqpaktmMU1WNJC/rcR54u07TtqqzC+g=";
    }
    .${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
}
