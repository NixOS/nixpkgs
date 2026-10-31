{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  npmHooks,
  versionCheckHook,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mcporter";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "openclaw";
    repo = "mcporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ilTScTb1vE5V4Qzh4aLa3bPGbv/khx1abvZs1rNvDsM=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-9sY8rfXf/y+XI8Jl+zIN0B3tq7FxBhYcejKx1yMcKj4=";
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

  preInstall = ''
    CI=true pnpm prune --prod --ignore-scripts
    # Clean up broken symlinks left behind by `pnpm prune`
    # https://github.com/pnpm/pnpm/issues/3645
    find node_modules -xtype l -delete
  '';

  dontNpmPrune = true;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TypeScript runtime and CLI for connecting to configured Model Context Protocol servers";
    homepage = "https://github.com/openclaw/mcporter";
    changelog = "https://github.com/openclaw/mcporter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mkg20001 ];
    mainProgram = "mcporter";
  };
})
