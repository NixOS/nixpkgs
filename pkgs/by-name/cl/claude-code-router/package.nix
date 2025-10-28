{
  buildNpmPackage,
  esbuild,
  fetchFromGitHub,
  lib,
  makeBinaryWrapper,
  nodejs_24,
  pnpm_9,
  versionCheckHook,
}:
let
  buildNpmPackage' = buildNpmPackage.override { nodejs = nodejs_24; };
in
buildNpmPackage' (finalAttrs: {
  pname = "claude-code-router";
  version = "1.0.64";

  src = fetchFromGitHub {
    owner = "musistudio";
    repo = "claude-code-router";
    rev = "1a4462a92362e8c41d4539dc1a79fb85fccf9559";
    hash = "sha256-q818e8PcKjdBqYk6WfGLKQ8pybXWVxmNV8KX7GjEQq0=";
  };

  postPatch = ''
    substituteInPlace src/cli.ts \
      --replace-fail '"node"' '"${lib.getExe nodejs_24}"'
  '';

  npmDeps = null;
  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname src;
    fetcherVersion = 2;
    hash = "sha256-BLPGTbDvvI40kuXfE/p3+s9hkE0reXr7OJA6UGXN4ys=";
  };

  nativeBuildInputs = [
    esbuild
    makeBinaryWrapper
    pnpm_9.configHook
  ];

  npmConfigHook = pnpm_9.configHook;

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
    makeBinaryWrapper ${lib.getExe nodejs_24} $out/bin/ccr \
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
    pnpmDeps = pnpm_9.fetchDeps {
      inherit (finalAttrs') pname src sourceRoot;
      fetcherVersion = 2;
      hash = "sha256-ZjYLUec9EADQmKfju8hMbq0y4f1TDVwjbe3yw8Gh4Ac=";
    };

    nativeBuildInputs = [
      pnpm_9.configHook
    ];

    npmConfigHook = pnpm_9.configHook;

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
