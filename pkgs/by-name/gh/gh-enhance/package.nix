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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "gh-enhance";
    rev = "v${finalAttrs.version}";
    hash = "sha256-IHtI8wnPLMkqxdBFXqkt6inYMOIqKjdTKdZbTxIhPzo=";
  };

  vendorHash = "sha256-rgql0vsHAzWeubw4EYBu/yPmm2QeADsIeACWsbcWtSk=";

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
