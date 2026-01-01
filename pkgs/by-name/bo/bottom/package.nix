{
  lib,
<<<<<<< HEAD
  stdenv,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  rustPlatform,
  fetchFromGitHub,
  autoAddDriverRunpath,
  installShellFiles,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bottom";
<<<<<<< HEAD
  version = "0.12.2";
=======
  version = "0.11.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = "bottom";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-+VfXxLKIdrg+ytmx29TPm46t3yhAgqBSJ+ykiIjuNmA=";
  };

  cargoHash = "sha256-dvU/iAgLC0+l8FH1bnOdIvZrXHqltE1hMkf+IaLQZxE=";
=======
    hash = "sha256-hyEYSkoV86BWVMjolU9IjU0rTABxE4ag26el0UydsFQ=";
  };

  cargoHash = "sha256-VnpSgaBxSHJj+brMtNwmbrXUN9H3y0oinF8ya+vsl88=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeBuildInputs = [
    autoAddDriverRunpath
    installShellFiles
  ];

  env = {
    BTM_GENERATE = true;
  };

  postInstall = ''
    installManPage target/tmp/bottom/manpage/btm.1
    installShellCompletion \
      target/tmp/bottom/completion/btm.{bash,fish} \
      --zsh target/tmp/bottom/completion/_btm

    install -Dm444 desktop/bottom.desktop -t $out/share/applications
<<<<<<< HEAD
    install -Dm644 assets/icons/bottom-system-monitor.svg -t $out/share/icons/hicolor/scalable/apps
  '';

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # fails to get list of processes due to sandboxing, this functionality works at runtime
    "--skip=collection::tests::test_data_collection"
  ];

=======
    install -Dm644 assets/icons/bottom.svg -t $out/share/icons/hicolor/scalable/apps
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/btm";
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/ClementTsang/bottom/blob/${finalAttrs.version}/CHANGELOG.md";
    description = "Cross-platform graphical process/system monitor with a customizable interface";
    homepage = "https://github.com/ClementTsang/bottom";
    license = lib.licenses.mit;
    mainProgram = "btm";
    maintainers = with lib.maintainers; [
      berbiche
      gepbird
    ];
  };
})
