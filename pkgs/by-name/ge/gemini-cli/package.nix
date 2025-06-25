{ lib, buildNpmPackage, fetchFromGitHub, nodejs, esbuild, typescript, git }:

buildNpmPackage {
  pname = "@google/gemini-cli";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
      src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    rev = "af4dfd9327950d99cc2740b3cdd91e3186258a7a";
    hash = "sha256-iUTdkaPVhC8DWFdzlhu7mGFRZnLLgL4eNrvmnveWzms=";
  };

  npmDepsHash = "sha256-2zyMrVykKtN+1ePQko9MVhm79p7Xbo9q0+r/P22buQA=";

  nativeBuildInputs = [
    nodejs
    esbuild
    typescript
    git
  ];

  prepack = ''
    mkdir -p packages/core/src
    echo "export const GIT_COMMIT_INFO = { hash: 'unknown', date: 'unknown' };" > packages/core/src/git-commit-info.js
  '';

  postInstall = ''
    # The path to the node_modules where the main package is installed
    target_node_modules=$out/lib/node_modules/@google/gemini-cli/node_modules

    # Remove the broken symlinks created by npm workspaces
    rm -f $target_node_modules/@google/gemini-cli
    rm -f $target_node_modules/@google/gemini-cli-core

    # Copy the actual built workspace packages into node_modules
    cp -r ./packages/cli $target_node_modules/@google/gemini-cli
    cp -r ./packages/core $target_node_modules/@google/gemini-cli-core
  '';

  meta = with lib; {
    description = "An open-source AI agent that brings the power of Gemini directly into your terminal.";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ projectinitiative ];
  };
}

