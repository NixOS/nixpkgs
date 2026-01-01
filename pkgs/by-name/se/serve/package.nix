{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nodejs,
  pnpm_9,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
}:
=======
}:

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
buildNpmPackage (finalAttrs: {
  pname = "serve";
  version = "14.2.4";

  src = fetchFromGitHub {
    owner = "vercel";
    repo = "serve";
    tag = finalAttrs.version;
    hash = "sha256-QVbau4MrpgEQkwlWx4tU9H93zdM0mSZgIzXpjHRM5mk=";
  };

  npmDeps = null;
<<<<<<< HEAD
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
=======
  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetcherVersion = 2;
    hash = "sha256-IJMu0XHwEn2TZP/He79FFGl/PeXOCTD51lIgmImpyKo=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ pnpm_9 ];
  npmConfigHook = pnpmConfigHook;
=======
  npmConfigHook = pnpm_9.configHook;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  dontNpmBuild = true;

  # takes too long to finish
  dontNpmPrune = true;

  meta = {
    description = "Static file serving and directory listing";
    homepage = "https://github.com/vercel/serve";
    downloadPage = "https://github.com/vercel/serve/releases";
    changelog = "https://github.com/vercel/serve/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prince213 ];
    mainProgram = "serve";
  };
})
