{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "conventional-changelog-cli";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "conventional-changelog";
    repo = "conventional-changelog";
    tag = "conventional-changelog-v${finalAttrs.version}";
    hash = "sha256-0Fee2sfLwxfE/MRLMUUMACTGVxnJJF1MPsWWzleVA3c=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-vOZnVCz5lFdVD2qmlHdTRxzuEjpR3W/rXfzvjvdOh9E=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    makeBinaryWrapper
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/conventional-changelog/
    mkdir $out/bin
    mv * $out/lib/node_modules/conventional-changelog/

    makeBinaryWrapper ${lib.getExe nodejs} $out/bin/conventional-changelog \
      --add-flags "$out/lib/node_modules/conventional-changelog/packages/conventional-changelog/dist/cli/index.js" \
      --set NODE_PATH "$out/lib/node_modules/conventional-changelog/node_modules"

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/lib/node_modules/conventional-changelog/packages/*/package.json \
      --replace-warn '"exports": "./src/index.ts"' '"exports": "./dist/index.js"'
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex"
      "conventional-changelog-v(.*)"
    ];
  };

  meta = {
    changelog = "https://github.com/conventional-changelog/conventional-changelog/releases/tag/${finalAttrs.src.tag}";
    description = "Generate a CHANGELOG from git metadata";
    homepage = "https://github.com/conventional-changelog/conventional-changelog";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.pyrox0 ];
    mainProgram = "conventional-changelog";
  };
})
