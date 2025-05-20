{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs_22, # Node ≥22 is required by codex-cli
  pnpm_10,
  makeBinaryWrapper,
  installShellFiles,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "codex";
  version = "0.1.2504301751"; # from codex-cli/package.json

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    rev = "463a230991393c7b39f2543a9766e6133ef65393";
    hash = "sha256-CSd5e6BsGEigENjPu6R6s+QhZRLQ2CTmI5XBI9mPkmA=";
  };

  pnpmWorkspaces = [ "@openai/codex" ];

  nativeBuildInputs = [
    nodejs_22
    pnpm_10.configHook
    makeBinaryWrapper
    installShellFiles
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

    # Install shell completions
    ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      $out/bin/codex completion bash > codex.bash
      $out/bin/codex completion zsh > codex.zsh
      $out/bin/codex completion fish > codex.fish
      installShellCompletion codex.{bash,zsh,fish}
    ''}

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
