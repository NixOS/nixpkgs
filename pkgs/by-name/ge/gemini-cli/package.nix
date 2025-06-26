{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  nodejs,
  git,
}:
buildNpmPackage rec {
  pname = "gemini-cli";
  version = "latest";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    rev = "ee5bf842eb5a4c6f19870a3c42eea35a8e3aacef";
    hash = "sha256-84aCujYelXDegJMBYeGk4ykjIjo1uDFH74oITc4nh2c=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-yoUAOo8OwUWG0gyI5AdwfRFzSZvSCd3HYzzpJRvdbiM=";
  };

  nativeBuildInputs = [
    nodejs
    git
  ];

  preConfigure = ''
    mkdir -p packages/generated
    echo "export const GIT_COMMIT_INFO = { commitHash: '${src.rev}' };" > packages/generated/git-commit.ts
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib

    cp -r node_modules $out/lib/

    rm $out/lib/node_modules/@google/gemini-cli
    rm $out/lib/node_modules/@google/gemini-cli-core

    cp -r packages/cli $out/lib/node_modules/@google/gemini-cli
    cp -r packages/core $out/lib/node_modules/@google/gemini-cli-core

    mkdir -p $out/bin
    ln -s ../lib/node_modules/@google/gemini-cli/dist/index.js $out/bin/gemini

    runHook postInstall
  '';

  postInstall = ''
    chmod +x $out/bin/gemini
  '';

  meta = {
    description = "A CLI for interacting with the Google Gemini family of models";
    homepage = "https://github.com/google-gemini/gemini-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cafkafk ];
  };
}
