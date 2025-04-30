{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_22, # Node ≥22 is required by codex-cli
  pnpm_10,
  makeBinaryWrapper,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "codex";
  version = "0.1.2504251709"; # from codex-cli/package.json

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    rev = "103093f79324482020490cb658cc1a696aece3bc";
    hash = "sha256-GmMQi67HRanGKhiTKX8wgnpUbA1UwkPVe3siU4qC02Y=";
  };

  pnpmWorkspaces = [ "@openai/codex" ];

  nativeBuildInputs = [
    nodejs_22
    pnpm_10.configHook
    makeBinaryWrapper
  ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    hash = "sha256-pPwHjtqqaG+Zqmq6x5o+WCT1H9XuXAqFNKMzevp7wTc=";
  };

  buildPhase = ''
    runHook preBuild
    pnpm --filter @openai/codex run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dest=$out/lib/node_modules/@openai/codex
    mkdir -p "$dest"
    cp -r codex-cli/dist codex-cli/bin codex-cli/package.json "$dest"
    cp LICENSE README.md "$dest"

    mkdir -p $out/bin
    makeBinaryWrapper ${nodejs_22}/bin/node $out/bin/codex --add-flags "$dest/bin/codex.js"

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.malo ];
    mainProgram = "codex";
  };
})
