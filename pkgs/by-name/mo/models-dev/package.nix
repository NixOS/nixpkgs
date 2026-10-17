{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
let
  node_modules =
    finalAttrs:
    stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) version src;

      __structuredAttrs = true;
      strictDeps = true;

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

        bun install \
          --cpu="*" \
          --frozen-lockfile \
          --ignore-scripts \
          --no-progress \
          --os="*"

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

      outputHash = "sha256-aL2kNCYF6Y4QnEvlpQ9U5Qe+K8a1J2X7BvJqE+BnRcY=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "models-dev";
  version = "0.0.5-unstable-2026-10-17";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "models.dev";
    rev = "d1853abfc1125d500cf04abaefc7b2839c8f43e1";
    hash = "sha256-C6qkWUUwv5NQ5iQGqC6a2N8axtOLzSDkbIhnHBs8ciA=";
  };

  node_modules = node_modules finalAttrs;

  nativeBuildInputs = [ bun ];

  configurePhase = ''
    runHook preConfigure

    cp -R $node_modules/. .

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    cd packages/web
    bun run ./script/build.ts
    bun ${./generate-schema.ts} ./dist/_api.json ./dist/model-schema.json

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/dist
    cp -R ./dist $out

    runHook postInstall
  '';

  passthru = {
    jsonschema = "${finalAttrs.finalPackage}/dist/model-schema.json";
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
        "--subpackage"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "Comprehensive open-source database of AI model specifications, pricing, and capabilities";
    homepage = "https://github.com/anomalyco/models.dev";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ delafthi ];
  };
})
