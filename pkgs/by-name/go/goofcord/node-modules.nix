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
      x86_64-linux = "sha256-EEl+hrdMR6z1PAy+uIhl2UYtajXWiUQMQxIfYpMRw6Y=";
      aarch64-linux = "sha256-ba+j8FGKNH3Mpql7xvLgHHuJxDGVlZ+TeZ3Oxsw3ot4=";
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";

  meta = {
    description = "Node modules for GoofCord";
    license = lib.licenses.osl3;
    platforms = lib.platforms.linux;
  };
}
