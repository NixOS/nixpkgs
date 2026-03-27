{
  lib,
  stdenv,
  ttyd,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "clive";
  version = "0.12.16";

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "clive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bZzK7RLAStRb9R3V/TK6tZV6yv1C7MGslAhhpWDzdWk=";
  };

  vendorHash = "sha256-BDspmaATLIfwyqxwJNJ24vpEETUWGVbobHWD2NRaOi4=";
  subPackages = [ "." ];
  buildInputs = [ ttyd ];
  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  ldflags = [
    "-X github.com/koki-develop/clive/cmd.version=v${finalAttrs.version}"
  ];

  postInstall = ''
    wrapProgram $out/bin/clive --prefix PATH : ${ttyd}/bin
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd clive \
      --bash <($out/bin/clive completion bash) \
      --fish <($out/bin/clive completion fish) \
      --zsh <($out/bin/clive completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doinstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automates terminal operations";
    homepage = "https://github.com/koki-develop/clive";
    changelog = "https://github.com/koki-develop/clive/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ misilelab ];
    mainProgram = "clive";
  };
})
