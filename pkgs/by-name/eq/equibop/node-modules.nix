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
  name = equibop.pname + "-modules";

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
      --force \
      --frozen-lockfile \
      --no-progress \

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -R ./node_modules $out

    runHook postInstall
  '';

  outputHash = "sha256-qAmSEruZk80JJVTmPuJ8ePfpDmNCR9IQC1puG1UtsjA=";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
}
