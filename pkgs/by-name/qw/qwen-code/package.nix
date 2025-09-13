{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  jq,
}:

buildNpmPackage (finalAttrs: {
  pname = "qwen-code";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "QwenLM";
    repo = "qwen-code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5qKSWbc0NPpgvt36T/gRSgm1+o2Pbdw3tgfcGba6YSs=";
  };

  patches = [
    # similar to upstream gemini-cli some node deps are missing resolved and integrity fields
    # upstream the problem is solved in master and in v0.4+, eventually the fix should arrive to qwen
    ./add-missing-resolved-integrity-fields.patch
  ];

  npmDepsHash = "sha256-tI8s3e3UXE+wV81ctuRsJb3ewL67+a+d9R5TnV99wz4=";

  nativeBuildInputs = [
    jq
  ];

  postPatch = ''
    # Remove node-pty dependencies from package.json
    jq 'del(.optionalDependencies."@lydell/node-pty")' package.json > package.json.tmp && mv package.json.tmp package.json
    jq 'del(.optionalDependencies."node-pty")' package.json > package.json.tmp && mv package.json.tmp package.json
    jq 'del(.optionalDependencies."@lydell/node-pty-darwin-arm64")' package.json > package.json.tmp && mv package.json.tmp package.json
    jq 'del(.optionalDependencies."@lydell/node-pty-darwin-x64")' package.json > package.json.tmp && mv package.json.tmp package.json
    jq 'del(.optionalDependencies."@lydell/node-pty-linux-x64")' package.json > package.json.tmp && mv package.json.tmp package.json
    jq 'del(.optionalDependencies."@lydell/node-pty-win32-arm64")' package.json > package.json.tmp && mv package.json.tmp package.json
    jq 'del(.optionalDependencies."@lydell/node-pty-win32-x64")' package.json > package.json.tmp && mv package.json.tmp package.json

    # Remove node-pty dependencies from packages/core/package.json
    jq 'del(.dependencies."@lydell/node-pty")' packages/core/package.json > packages/core/package.json.tmp && mv packages/core/package.json.tmp packages/core/package.json
    jq 'del(.dependencies."node-pty")' packages/core/package.json > packages/core/package.json.tmp && mv packages/core/package.json.tmp packages/core/package.json
    jq 'del(.dependencies."@lydell/node-pty-darwin-arm64")' packages/core/package.json > packages/core/package.json.tmp && mv packages/core/package.json.tmp packages/core/package.json
    jq 'del(.dependencies."@lydell/node-pty-darwin-x64")' packages/core/package.json > packages/core/package.json.tmp && mv packages/core/package.json.tmp packages/core/package.json
    jq 'del(.dependencies."@lydell/node-pty-linux-x64")' packages/core/package.json > packages/core/package.json.tmp && mv packages/core/package.json.tmp packages/core/package.json
    jq 'del(.dependencies."@lydell/node-pty-win32-arm64")' packages/core/package.json > packages/core/package.json.tmp && mv packages/core/package.json.tmp packages/core/package.json
    jq 'del(.dependencies."@lydell/node-pty-win32-x64")' packages/core/package.json > packages/core/package.json.tmp && mv packages/core/package.json.tmp packages/core/package.json
  '';

  buildPhase = ''
    runHook preBuild

    npm run generate
    npm run bundle

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/qwen-code
    cp -r bundle/* $out/share/qwen-code/
    patchShebangs $out/share/qwen-code
    ln -s $out/share/qwen-code/gemini.js $out/bin/qwen

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Coding agent that lives in digital world";
    homepage = "https://github.com/QwenLM/qwen-code";
    mainProgram = "qwen";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      lonerOrz
      taranarmo
    ];
  };
})
