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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "steipete";
    repo = "mcporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IH0jYDkmEPPvy/g5+YfkNBwG2QUMwkuVCnSeSTsNHNw=";
  };

  # Fix lockfile specifier mismatch: package.json overrides vite to exact
  # "8.0.8" but the lockfile still records specifier as "^8.0.8"
  postPatch = ''
    substituteInPlace pnpm-lock.yaml \
      --replace-fail 'specifier: ^8.0.8' 'specifier: 8.0.8'
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      postPatch
      ;
    fetcherVersion = 2;
    hash = "sha256-dCue5Id5gcddoqoHKeB3uwxR4jtoBJx/mUzHLnb8o14=";
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
