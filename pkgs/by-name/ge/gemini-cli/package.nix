{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  writeShellApplication,
  cacert,
  curl,
  gnused,
  jq,
  nix-prefetch-github,
  prefetch-npm-deps,
  gitUpdater,
}:

buildNpmPackage (finalAttrs: {
  pname = "gemini-cli";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P8ZjUMkgl/AH1k4H6jOMg2hVXY3kqPi68lPAYvVcwvc=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-d1PQhXk9Nz0EduemwuLfS0lNOR+GwSc53wBn/k/l5tU=";
  };

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
    maintainers = with lib.maintainers; [ donteatoreo ];
    platforms = lib.platforms.all;
    mainProgram = "gemini";
  };
})
