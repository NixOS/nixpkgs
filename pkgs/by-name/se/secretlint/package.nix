{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  nodejs,
  pnpm_10,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "secretlint";
  version = "11.0.2";

  src = fetchFromGitHub {
    owner = "secretlint";
    repo = "secretlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LJ1zYv0w7e9fPLfhzfCdasloRUdcy8lfMIQTyHqAY/Y=";
  };

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-jEmpyj83ORKUWHzVYoFzKdaB7epLam33nP7t0z5QmlE=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm_10.configHook
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib
    cp -r node_modules $out/lib/
    cp -r packages $out/lib/
    cp -r examples $out/lib/
    makeWrapper ${lib.getExe nodejs} $out/bin/secretlint \
      --inherit-argv0 \
      --prefix NODE_PATH : "$out/lib/node_modules" \
      --add-flags $out/lib/packages/secretlint/bin/secretlint.js
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pluggable linting tool to prevent committing credentials";
    homepage = "https://github.com/secretlint/secretlint";
    changelog = "https://github.com/secretlint/secretlint/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.amadejkastelic ];
    mainProgram = "secretlint";
  };
})
