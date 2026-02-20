# fixed output derrivation adapted from
# https://github.com/NixOS/nixpkgs/blob/28c3f83a9a77e3ada57afb71cc4052d2c435597a/pkgs/by-name/op/opencode/package.nix#L59-L122
{
  lib,
  stdenvNoCC,
  equibop,
  bun,
  writableTmpDirAsHomeHook,
}:
stdenvNoCC.mkDerivation {
  inherit (equibop) version src;
  pname = equibop.pname + "-modules";

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
        --filter=equibop \
        --force \
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
      x86_64-linux = "sha256-os/+0Xb3N1NMtTMP/G9bhELoQF3kDfqzuKUP5RcelJI=";
      aarch64-linux = "sha256-EvHJQGtW62AOyMnWAEK0HsrwU875JrbMeqD+ctBEI3k=";
    }
    .${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system ${stdenvNoCC.hostPlatform.system}");
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
}
