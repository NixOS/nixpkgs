{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  makeWrapper,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
}:
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
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-RiZrQFvEya7l3bhfIhDmdegovGrNYG+95GsAj1H828g=";
  };

  nativeBuildInputs = [ pnpm_10 ];
  npmConfigHook = pnpmConfigHook;

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
