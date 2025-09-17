{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  ripgrep,
  jq,
  pkg-config,
  libsecret,
}:

buildNpmPackage (finalAttrs: {
  pname = "gemini-cli";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SyYergPmEyIcDyU0tF20pvu1qOCRfMRozh0/9nnaefU=";
  };

  npmDepsHash = "sha256-4S1wMl1agTYOwJ8S/CsXHG+JRx40Nee23TmoJyTYoII=";

  nativeBuildInputs = [
    jq
    pkg-config
  ];

  buildInputs = [
    ripgrep
    libsecret
  ];

  preConfigure = ''
    mkdir -p packages/generated
    echo "export const GIT_COMMIT_INFO = { commitHash: '${finalAttrs.src.rev}' };" > packages/generated/git-commit.ts
  '';

  postPatch = ''
    # Remove node-pty dependency from package.json
    jq 'del(.optionalDependencies."node-pty")' package.json > package.json.tmp && mv package.json.tmp package.json

    # Remove node-pty dependency from packages/core/package.json
    jq 'del(.optionalDependencies."node-pty")' packages/core/package.json > packages/core/package.json.tmp && mv packages/core/package.json.tmp packages/core/package.json

    # Remove @lvce-editor/ripgrep dependency from package.json
    substituteInPlace package.json --replace-fail '"@lvce-editor/ripgrep": "^1.6.0",' ""

    # Remove @lvce-editor/ripgrep dependency from packages/core/package.json
    substituteInPlace packages/core/package.json --replace-fail '"@lvce-editor/ripgrep": "^1.6.0",' ""

    # Modify ripGrep.ts to use system ripgrep instead of @lvce-editor/ripgrep
    substituteInPlace packages/core/src/tools/ripGrep.ts \
      --replace-fail "import { rgPath } from '@lvce-editor/ripgrep';" "const rgPath = 'rg';"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/gemini-cli}

    cp -r node_modules $out/share/gemini-cli/

    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-core
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-a2a-server
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-test-utils
    rm -f $out/share/gemini-cli/node_modules/gemini-cli-vscode-ide-companion
    cp -r packages/cli $out/share/gemini-cli/node_modules/@google/gemini-cli
    cp -r packages/core $out/share/gemini-cli/node_modules/@google/gemini-cli-core
    cp -r packages/a2a-server $out/share/gemini-cli/node_modules/@google/gemini-cli-a2a-server

    ln -s $out/share/gemini-cli/node_modules/@google/gemini-cli/dist/index.js $out/bin/gemini
    chmod +x "$out/bin/gemini"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI agent that brings the power of Gemini directly into your terminal";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      FlameFlag
      taranarmo
    ];
    platforms = lib.platforms.all;
    mainProgram = "gemini";
  };
})
