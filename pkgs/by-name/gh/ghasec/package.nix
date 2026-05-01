{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "ghasec";
  version = "0.11.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "koki-develop";
    repo = "ghasec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z6UwSq0NlSgV3m7UeLVdWiJ81djhf+P1Y3xKjkbs6Yg=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-At3MKC0PZ5v6TG+GyrtCDrzucI0hg0woCkDNOCj+xh0=";

  checkPhase = "go test ."; # since CI fails in Version 0.11.2, specify the test command

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/koki-develop/ghasec/cmd.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd 'ghasec' \
      --bash <("$out/bin/ghasec" completion bash) \
      --zsh <("$out/bin/ghasec" completion zsh) \
      --fish <("$out/bin/ghasec" completion fish)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    homepage = "https://github.com/koki-develop/ghasec/";
    description = "🫴 Catch security risks in your GitHub Actions workflows.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ misogihagi ];
    mainProgram = "ghasec";
  };
})
