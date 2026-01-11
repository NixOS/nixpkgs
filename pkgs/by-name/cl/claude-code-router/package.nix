{
  buildNpmPackage,
  esbuild,
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nodejs_20,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  versionCheckHook,
}:
let
  nodejs = nodejs_20;
  buildNpmPackage' = buildNpmPackage.override { inherit nodejs; };
  pnpm' = pnpm_10.override { inherit nodejs; };
in
buildNpmPackage' (finalAttrs: {
  pname = "claude-code-router";
  version = "1.0.73";

  src = fetchFromGitHub {
    owner = "musistudio";
    repo = "claude-code-router";
    rev = "a7e20325dbb2a8827db0c9ee12924bdecfa19fd9";
    hash = "sha256-E5m5DiuCaZy8ac4bejpnyooaJ+YKc0ZqMIOhI2aOclk=";
  };

  postPatch = ''
    substituteInPlace src/cli.ts \
      --replace-fail '"node"' '"${lib.getExe nodejs}"'
  '';

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname src;
    pnpm = pnpm';
    fetcherVersion = 2;
    hash = "sha256-xvbw0+w6LxiQj2CpF+diVTsoKrxT8HXub1ASrGrlXR4=";
  };

  nativeBuildInputs = [
    esbuild
    makeBinaryWrapper
    pnpm'
  ];

  npmConfigHook = pnpmConfigHook;

  buildPhase = ''
    runHook preBuild

    esbuild src/cli.ts --bundle --platform=node --outfile=dist/cli.js

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/claude-code-router/dist
    cp dist/cli.js $out/lib/claude-code-router/dist/
    cp node_modules/tiktoken/tiktoken_bg.wasm $out/lib/claude-code-router/dist/
    cp ${finalAttrs.passthru.ui}/index.html $out/lib/claude-code-router/dist/

    mkdir -p $out/bin
    makeBinaryWrapper ${lib.getExe nodejs} $out/bin/ccr \
      --add-flags "$out/lib/claude-code-router/dist/cli.js"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";

  passthru.ui = buildNpmPackage' (finalAttrs': {
    pname = finalAttrs.pname + "-ui";
    inherit (finalAttrs) version src;

    sourceRoot = "${finalAttrs'.src.name}/ui";

    npmDeps = null;
    pnpmDeps = fetchPnpmDeps {
      inherit (finalAttrs') pname src sourceRoot;
      pnpm = pnpm';
      fetcherVersion = 2;
      hash = "sha256-YtOcuqhJLJYg0C8J0/THA7UfKMVHE8oN5BcJQ2zSpWQ=";
    };

    nativeBuildInputs = [
      pnpm'
    ];

    npmConfigHook = pnpmConfigHook;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp dist/index.html $out/

      runHook postInstall
    '';
  });

  meta = {
    description = "Tool to route Claude Code requests to different models and customize any request";
    homepage = "https://github.com/musistudio/claude-code-router";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      prince213
    ];
    mainProgram = "ccr";
  };
})
