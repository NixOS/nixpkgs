{
  buildPackages,
  fetchFromGitHub,
  gitMinimal,
  installShellFiles,
  lib,
  nix-update-script,
  rustPlatform,
  stdenv,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-vault";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "roman-16";
    repo = "git-vault";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PfMiKFLm4yq7Iw4vNlUAblXzBaoz2uMND3hAxxxJZ2U=";
  };

  cargoHash = "sha256-CmSes391V1/fbSuh2MrESO7J3wzq0pBwMNivog6tKAE=";

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ gitMinimal ];

  postInstall =
    let
      gitVault = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/git-vault";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      ${gitVault} man "$TMPDIR/man"
      installManPage "$TMPDIR"/man/*.1

      installShellCompletion --cmd git-vault \
        --bash <(${gitVault} completions bash) \
        --fish <(${gitVault} completions fish) \
        --zsh <(${gitVault} completions zsh)
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Transparent encryption for git that collapses everything it protects into one opaque file";
    homepage = "https://github.com/roman-16/git-vault";
    changelog = "https://github.com/roman-16/git-vault/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "git-vault";
    maintainers = with lib.maintainers; [ roman-16 ];
    platforms = lib.platforms.unix;
  };
})
