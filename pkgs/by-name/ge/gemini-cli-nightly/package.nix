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
  ...
}:

buildNpmPackage (finalAttrs: {
  pname = "gemini-cli";
  version = "0.1.9-nightly.250708.137ffec3";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    rev = "821abfc456cb4664f8e7cfdc5856b1dd6564fecd";
    hash = "sha256-2w28N6Fhm6k3wdTYtKH4uLPBIOdELd/aRFDs8UMWMmU=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-yoUAOo8OwUWG0gyI5AdwfRFzSZvSCd3HYzzpJRvdbiM=";
  };

  postPatch = ''
    sed -i 's/"version": "0.1.5"/"version": "${finalAttrs.version}"/' package.json
    sed -i 's/"version": "0.1.5"/"version": "${finalAttrs.version}"/' packages/cli/package.json
    sed -i 's/"version": "0.1.5"/"version": "${finalAttrs.version}"/' packages/core/package.json
  '';

  preBuild = ''
    mkdir -p packages/cli/src/generated
    # The TypeScript source file
    echo "export const GIT_COMMIT_INFO = { commitHash: '${finalAttrs.src.rev}' };" > packages/cli/src/generated/git-commit.ts
    # The TypeScript declaration file to satisfy the strict compiler
    echo "export const GIT_COMMIT_INFO: { commitHash: string };" > packages/cli/src/generated/git-commit.d.ts
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
