{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  gitUpdater,
}:

buildNpmPackage (finalAttrs: {
  pname = "gemini-cli";
  version = "0.1.21";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eS83Uwp6LzyQuIx2jirXnJ6Xb2XEaAKLnS9PMKTIvyI=";
  };

  patches = [
    # FIXME: remove once https://github.com/google-gemini/gemini-cli/pull/5336 is merged
    ./restore-missing-dependencies-fields.patch
  ];

  npmDepsHash = "sha256-5pFnxZFhVNxYLPJClYq+pe4wAX5623Y3hFj8lIq00+E=";

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
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-test-utils
    rm -f $out/share/gemini-cli/node_modules/gemini-cli-vscode-ide-companion
    cp -r packages/cli $out/share/gemini-cli/node_modules/@google/gemini-cli
    cp -r packages/core $out/share/gemini-cli/node_modules/@google/gemini-cli-core

    ln -s $out/share/gemini-cli/node_modules/@google/gemini-cli/dist/index.js $out/bin/gemini
    runHook postInstall
  '';

  postInstall = ''
    chmod +x "$out/bin/gemini"
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "AI agent that brings the power of Gemini directly into your terminal";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      donteatoreo
      taranarmo
    ];
    platforms = lib.platforms.all;
    mainProgram = "gemini";
  };
})
