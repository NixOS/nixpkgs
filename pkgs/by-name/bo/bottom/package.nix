{
  lib,
  stdenv,
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
  version = "0.14.3";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = "bottom";
    tag = finalAttrs.version;
    hash = "sha256-DJ1Vw1YG4CXhXUwFh2pGyH6lqLw1oHG18AEXlC4xvZk=";
  };

  cargoHash = "sha256-SUR1O5Sm3CFxjkxkPWih7gnvf7L04D+x5SUFXvA/KgQ=";

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
    install -Dm644 assets/icons/bottom-system-monitor.svg -t $out/share/icons/hicolor/scalable/apps
  '';

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # fails to get list of processes due to sandboxing, this functionality works at runtime
    "--skip=collection::tests::test_data_collection"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/btm";

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
