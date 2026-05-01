{
  lib,
  fetchFromGitHub,
  buildGoModule,
  installShellFiles,
  stdenv,
  writableTmpDirAsHomeHook,
}:
buildGoModule (finalAttrs: {
  pname = "gh-enhance";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-enhance";
    rev = "v${finalAttrs.version}";
    hash = "sha256-g6nhEcBt72sol/49FVlYSo9HKtWHfj+zKw7FZ0ZjKXI=";
  };

  vendorHash = "sha256-us25CXQC3cd3BTa+wOYArbBiMtwkgpfeCQoD3S7+3rU=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dlvhdr/gh-enhance/cmd.Version=${finalAttrs.version}"
  ];

  checkFlags = [
    # requires network
    "-skip=TestFullOutput"
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];
  doInstallCheck = true;
  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gh-enhance \
      --bash <($out/bin/gh-enhance completion bash) \
      --fish <($out/bin/gh-enhance completion fish) \
      --zsh <($out/bin/gh-enhance completion zsh)
  '';
  meta = {
    changelog = "https://github.com/dlvhdr/gh-enhance/releases/tag/${finalAttrs.src.rev}";
    description = "Terminal UI for GitHub Actions";
    homepage = "https://www.gh-dash.dev/enhance";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ replicapra ];
    mainProgram = "gh-enhance";
  };
})
