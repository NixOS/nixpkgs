{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  versionCheckHook,

  nodejs,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ctx7";
  version = "0.3.9";

  src = fetchFromGitHub {
    owner = "upstash";
    repo = "context7";
    tag = "${finalAttrs.pname}@${finalAttrs.version}";
    hash = "sha256-nrJCYezH9VDd1Ptpg5xATx0ByweTw8dkKT2y3rnFHd8=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    makeWrapper
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-8RRHfCTZVC91T1Qx+ACCo2oG4ZwMNy5WYakCjmBhe3Q=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm --filter ${finalAttrs.pname} build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pnpm \
      --filter ${finalAttrs.pname} \
      --offline \
      --config.inject-workspace-packages=true \
      --config.shamefully-hoist=true \
      deploy $out/lib/ctx7

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/ctx7 \
      --add-flags "$out/lib/ctx7/dist/index.js"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "${finalAttrs.pname}@(.*)"
    ];
  };

  meta = {
    description = "Context7 CLI - Manage AI coding skills and documentation context";
    homepage = "https://context7.com/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arunoruto ];
    mainProgram = "ctx7";
    platforms = lib.platforms.unix;
  };
})
