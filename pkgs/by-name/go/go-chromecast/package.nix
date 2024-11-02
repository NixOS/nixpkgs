{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  installShellFiles,
  stdenvNoCC,
  versionCheckHook,
}:

# "go test" fails with go 1.23
buildGo122Module rec {
  pname = "go-chromecast";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "vishen";
    repo = "go-chromecast";
    rev = "refs/tags/v${version}";
    hash = "sha256-Kzo8iWj4mtnX1Jxm2sLsnmEOmpzScxWHZ/sLYYm3vQI=";
  };

  vendorHash = "sha256-cEUlCR/xtPJJSWplV1COwV6UfzSmVArF4V0pJRk+/Og=";

  CGO_ENABLED = 0;

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
