{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pnpm,
  npmHooks,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mgrep";
<<<<<<< HEAD
  version = "0.1.6";
=======
  version = "0.1.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mixedbread-ai";
    repo = "mgrep";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-jGzOwonT4nq0nMUBBp4Y7BvwTerHLzkTMss9glM+uP4=";
  };

  pnpmDeps = fetchPnpmDeps {
=======
    hash = "sha256-FwgUK5vPXba8cmGrsSItbhXYDNPxkr7x5u1jPxs3SAA=";
  };

  pnpmDeps = pnpm.fetchDeps {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-oq7jczTfm6CgLAUYftBlAYK6MFELDRfXCFtjsLWV8mU=";
  };

  nativeBuildInputs = [
    nodejs
<<<<<<< HEAD
    pnpmConfigHook
    pnpm
=======
    pnpm.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
