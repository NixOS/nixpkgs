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
stdenv.mkDerivation rec {
  pname = "fish-lsp";
  version = "1.0.8-1";

  src = fetchFromGitHub {
    owner = "ndonfris";
    repo = "fish-lsp";
    rev = "refs/tags/v${version}";
    hash = "sha256-u125EZXQEouVbmJuoW3KNDNqLB5cS/TzblXraClcw6Q=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-hHw7DbeqaCapqx4dK5Y3sPut94ist9JOU8g9dd6gBdo=";
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
    maintainers = with lib.maintainers; [ petertriho ];
    platforms = lib.platforms.unix;
  };
}
