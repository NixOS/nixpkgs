{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "otel-tui";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "ymtdzzz";
    repo = "otel-tui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+OvbBmFGyS5tpFtgn1DDxWp+LD5BAl9ojSIDGokfcRk=";
  };

  vendorHash = "sha256-2cH4DYogEfVywynfpZk6XfaiZaNyzbsDiwGSwolREPQ=";

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
