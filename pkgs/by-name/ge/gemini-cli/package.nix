{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  ripgrep,
}:

buildNpmPackage (finalAttrs: {
  pname = "gemini-cli";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nlDXWAfFmhRwfZ46knUeF5ar6huPFLJ5wSxcts4bjfM=";
  };

  patches = [
    # FIXME: remove once https://github.com/google-gemini/gemini-cli/pull/5336 is merged
    # FIXME: PR is merged though package is failing without the patch
    ./restore-missing-dependencies-fields.patch
    # removes @lvce-editor/ripgrep and make upstream code to use ripgrep from nixpkgs
    ./replace-npm-s-ripgrep-with-local.patch
  ];

  npmDepsHash = "sha256-q7E5YEMjHs9RvfT4ctzltqHr/+cCh3M+G6D2MkLiJFg=";

  buildInputs = [
    ripgrep
  ];

  preConfigure = ''
    mkdir -p packages/generated
    echo "export const GIT_COMMIT_INFO = { commitHash: '${finalAttrs.src.rev}' };" > packages/generated/git-commit.ts
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
