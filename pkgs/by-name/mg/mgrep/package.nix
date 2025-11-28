{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
  npmHooks,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mgrep";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "mixedbread-ai";
    repo = "mgrep";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FwgUK5vPXba8cmGrsSItbhXYDNPxkr7x5u1jPxs3SAA=";
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-oq7jczTfm6CgLAUYftBlAYK6MFELDRfXCFtjsLWV8mU=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
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
