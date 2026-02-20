{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_20,
  pnpm_9,
  npmHooks,
  pnpmConfigHook,
  fetchPnpmDeps,
}:
let
  pname = "openspec";
  version = "1.1.1";
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Fission-AI";
    repo = "OpenSpec";
    tag = "v${version}";
    hash = "sha256-XdE8WGXdBm9FQKZJIJtnPCqpD20ontpINlfmqFmts3U=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    hash = "sha256-9s2kdvd7svK4hofnD66HkDc86WTQeayfF5y7L2dmjNg=";
    fetcherVersion = 3;
  };

  nativeBuildInputs = [
    nodejs_20
    npmHooks.npmInstallHook
    pnpmConfigHook
    pnpm_9
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  dontNpmPrune = true;

  meta = {
    description = "AI-native system for spec-driven development";
    homepage = "https://github.com/Fission-AI/OpenSpec";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "openspec";
    platforms = lib.platforms.all;
  };
})
