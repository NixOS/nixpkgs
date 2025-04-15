{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenvNoCC,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "go-chromecast";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = "go-chromecast";
    tag = "v${version}";
    hash = "sha256-6I10UZ7imH1R78L2uM/697PskPYjhKSiPHoMM7EFElU=";
  };

  vendorHash = "sha256-cu8PuZLkWLatU46VieaeoV5oyejyjR0uVUMVzOrheLM=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.commit=${src.rev}"
    "-X=main.date=unknown"
  ];

  doInstallCheck = true;

  nativeBuildInputs = [ installShellFiles ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd go-chromecast \
      --bash <($out/bin/go-chromecast completion bash) \
      --fish <($out/bin/go-chromecast completion fish) \
      --zsh <($out/bin/go-chromecast completion zsh)
  '';

  meta = {
    homepage = "https://github.com/vishen/go-chromecast";
    description = "CLI for Google Chromecast, Home devices and Cast Groups";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.zi3m5f ];
    mainProgram = "go-chromecast";
  };
}
