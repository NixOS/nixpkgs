{
  fetchFromGitHub,
  fetchYarnDeps,
  fish,
  installShellFiles,
  lib,
  makeWrapper,
  nix-update-script,
  nodejs,
  npmHooks,
  stdenv,
  which,
  yarnBuildHook,
  yarnConfigHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "fish-lsp";
  version = "1.0.9-1";

  src = fetchFromGitHub {
    owner = "ndonfris";
    repo = "fish-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NyEhvW5NMqvESdbauxur7xWAzQiQdTVklGMYhckNAnw=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-xB4kWpPQbA1OkXNr5sozPIP96dLJhwoDUpesE6DORzg=";
  };

  nativeBuildInputs = [
    yarnBuildHook
    yarnConfigHook
    npmHooks.npmInstallHook
    nodejs
    installShellFiles
    makeWrapper
    fish
  ];

  yarnBuildScript = "setup";

  postBuild = ''
    yarn --offline compile
  '';

  # We do it in postPatch, since it needs to be fixed before buildPhase
  postPatch = ''
    patchShebangs bin/fish-lsp
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fish-lsp
    cp -r . $out/share/fish-lsp

    makeWrapper ${lib.getExe nodejs} "$out/bin/fish-lsp" \
      --add-flags "$out/share/fish-lsp/out/cli.js" \
      --prefix PATH : "${
        lib.makeBinPath [
          fish
          which
        ]
      }"

    ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd fish-lsp \
        --fish <($out/bin/fish-lsp complete --fish)
    ''}

    runHook postInstall
  '';

  doDist = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "LSP implementation for the fish shell language";
    homepage = "https://github.com/ndonfris/fish-lsp";
    license = lib.licenses.mit;
    mainProgram = "fish-lsp";
    maintainers = with lib.maintainers; [
      llakala
      petertriho
    ];
    platforms = lib.platforms.unix;
  };
})
