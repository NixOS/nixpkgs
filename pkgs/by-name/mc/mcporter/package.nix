{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mcporter";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "mcporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1wBdYetYu+R04Fl50KR3zZK3QO6S95GV+PEO9k3Thhc=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-TZfEoUSjba8cRz6L9uY2PGskYsR7S/xAahiKLd8dhFM=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    npmHooks.npmInstallHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  dontNpmPrune = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TypeScript runtime and CLI for connecting to configured Model Context Protocol servers";
    homepage = "https://github.com/steipete/mcporter";
    changelog = "https://github.com/steipete/mcporter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mkg20001 ];
    mainProgram = "mcporter";
  };
})
