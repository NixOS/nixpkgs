{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "otelgen";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "krzko";
    repo = "otelgen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7VsWlOvsO+UC5GWunE9O/lMfh5BzXlXOAUOlKTlA0VI=";
  };

  vendorHash = "sha256-CJerNjXZSJ54FoNeKbvJGFjbFcSpnztUXa4o65YdcOY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.tag}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool to generate synthetic OpenTelemetry logs, metrics and traces using OTLP (gRPC and HTTP)";
    homepage = "https://github.com/krzko/otelgen";
    changelog = "https://github.com/krzko/otelgen/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "otelgen";
  };
})
