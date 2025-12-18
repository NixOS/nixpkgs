{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  npmHooks,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mgrep";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "mixedbread-ai";
    repo = "mgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dV5KeeOQIilrUottObJheVNZFMlxIlMZ7l8TygTbOvk=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-pwLXZ7DsANhF+6112jfXVMx4qsPmRWPTMI7i4WRPx1Q=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    npmHooks.npmInstallHook
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  dontNpmPrune = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Semantic grep for local files using Mixedbread embeddings";
    homepage = "https://github.com/mixedbread-ai/mgrep";
    changelog = "https://github.com/mixedbread-ai/mgrep/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ andrewgazelka ];
    mainProgram = "mgrep";
  };
})
