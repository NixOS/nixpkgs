{
  lib,
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
  version = "0.11.4";

  src = fetchFromGitHub {
    owner = "ClementTsang";
    repo = "bottom";
    tag = finalAttrs.version;
    hash = "sha256-hyEYSkoV86BWVMjolU9IjU0rTABxE4ag26el0UydsFQ=";
  };

  cargoHash = "sha256-VnpSgaBxSHJj+brMtNwmbrXUN9H3y0oinF8ya+vsl88=";

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
    install -Dm644 assets/icons/bottom.svg -t $out/share/icons/hicolor/scalable/apps
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/btm";
  versionCheckProgramArg = "--version";

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
