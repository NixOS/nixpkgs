{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "otel-tui";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "ymtdzzz";
    repo = "otel-tui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+OvbBmFGyS5tpFtgn1DDxWp+LD5BAl9ojSIDGokfcRk=";
  };

  vendorHash = "sha256-7/D9FUMiCb/I3WFGiJKNsl4lUvr96+yvZ+MxzDw6Quw=";

  # The project uses Go workspaces (go.work) with multiple modules.
  # We need to use 'go work vendor' instead of 'go mod vendor' to properly
  # vendor all workspace dependencies.
  overrideModAttrs = _: {
    buildPhase = ''
      runHook preBuild
      go work vendor
      runHook postBuild
    '';
  };

  # Tests require a TTY/terminal which isn't available in the build environment
  doCheck = false;

  meta = {
    description = "Terminal OpenTelemetry viewer inspired by otel-desktop-viewer";
    homepage = "https://github.com/ymtdzzz/otel-tui";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ brancengregory ];
    mainProgram = "otel-tui";
  };
})
