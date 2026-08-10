{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
let
  pname = "models-dev";
  version = "sdk-v0.0.5-unstable-2026-08-04";
  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "models.dev";
    rev = "183bea88e4c0e9922c81eddb3987d9edb3a640ed";
    hash = "sha256-h7GsDMuZFOzFVR0Yp3C0fEJAqQi0XLrC/hohMUKE6/8=";
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
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
        "--subpackage"
        "node_modules"
      ];
    };
    jsonschema = "${finalAttrs.finalPackage}/dist/model-schema.json";
  };

  meta = {
    description = "Comprehensive open-source database of AI model specifications, pricing, and capabilities";
    homepage = "https://github.com/anomalyco/models.dev";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ delafthi ];
  };
})
