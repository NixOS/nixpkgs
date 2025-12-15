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
  version = "1.0.10";

  src = fetchFromGitHub {
    owner = "ndonfris";
    repo = "fish-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OZiqEef4jE1H47mweVCzhaRCSsFdpgUdCSuhWRz2n2M=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-N9P2mmqAfbg/Kpqx+vZbb+fhaD1I/3UjiJaEqFPJyO0=";
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

  # fish-lsp adds tags for all its pre-release versions, which leads to
  # incorrect r-ryantm bumps. This regex allows a dash at the end followed by a
  # number (like `v1.0.9-1`). but it prevents matches with a dash followed by
  # text (like `v1.0.11-pre.10`). or, of course, no dash at all
  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(\\d+\\.\\d+\\.\\d+(?:-\\d+)?)$"
    ];
  };

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
