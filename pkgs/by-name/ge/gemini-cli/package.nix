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
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "google-gemini";
    repo = "gemini-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DAenod/w9BydYdYsOnuLj7kCQRcTnZ81tf4MhLUug6c=";
  };

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-otogkSsKJ5j1BY00y4SRhL9pm7CK9nmzVisvGCDIMlU=";
  };

  preConfigure = ''
    mkdir -p packages/generated
    echo "export const GIT_COMMIT_INFO = { commitHash: '${finalAttrs.src.rev}' };" > packages/generated/git-commit.ts
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib"

    cp -r node_modules "$out/lib/"

    rm -f "$out/lib/node_modules/@google/gemini-cli"
    rm -f "$out/lib/node_modules/@google/gemini-cli-core"

    cp -r packages/cli "$out/lib/node_modules/@google/gemini-cli"
    cp -r packages/core "$out/lib/node_modules/@google/gemini-cli-core"

    mkdir -p "$out/bin"
    ln -s ../lib/node_modules/@google/gemini-cli/dist/index.js "$out/bin/gemini"

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
