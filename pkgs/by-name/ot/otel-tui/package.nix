{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "otel-tui";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "ymtdzzz";
    repo = "otel-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-teTV4i27Xjf5E1/2C1e8HFf6Tkct2wgZZfu9SSM18II=";
  };

  vendorHash = "sha256-5ki/hR809LmMEHV8Mb7n2nEETAZR2Qs29AW5vvSzuu4=";

  env.GOWORK = "off";

  ldflags = [
    "-s"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "." ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal OpenTelemetry viewer inspired by otel-desktop-viewer";
    homepage = "https://github.com/ymtdzzz/otel-tui";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "otel-tui";
  };
})
