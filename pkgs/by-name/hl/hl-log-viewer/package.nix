{
  lib,
  stdenv,
  rustPlatform,
  installShellFiles,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hl-log-viewer";
<<<<<<< HEAD
  version = "0.33.1";
=======
  version = "0.32.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "pamburus";
    repo = "hl";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-xsBJIId5F1AUJ+Si1ymCUr27Qb4XRc8fObjT5kcumhM=";
  };

  cargoHash = "sha256-eHpFXq8ez8xIMhkQ2m/sR8OFU9edid3/hnBNYP1HmL8=";
=======
    hash = "sha256-JG5+RpUc8UGYxSlEX0c+dcUU2fFuVEwz/duK94XYkOc=";
  };

  cargoHash = "sha256-dIUQVLjjlQGHrMgWUeFc3R/QJbddRG8wmZklUHQTaas=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd hl \
      --bash <($out/bin/hl --shell-completions bash) \
      --fish <($out/bin/hl --shell-completions fish) \
      --zsh <($out/bin/hl --shell-completions zsh)
    $out/bin/hl --man-page >hl.1
    installManPage hl.1
  '';

  checkFlags = [
    # test broken on zero-width TTY, see https://github.com/pamburus/hl/issues/1140
    "--skip=help::tests::test_formatter_new"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/hl";
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "JSON and logfmt log converter to human readable representation";
    homepage = "https://github.com/pamburus/hl";
    changelog = "https://github.com/pamburus/hl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "hl";
    maintainers = with lib.maintainers; [ petrzjunior ];
  };
})
