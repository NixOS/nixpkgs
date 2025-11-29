{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "resterm";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "unkn0wn-root";
    repo = "resterm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yGFHCJUK9Cu3ZjSM59qY1y5iLJcbsB7WdZJ0XjJpO3g=";
  };

  vendorHash = "sha256-xM2X+ygaTQedeiy1qrRq5BYO0Jn9C44VR21gW/wvw1U=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
    "-X main.date=1970-01-01T00:00:00Z"
  ];

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "-version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal client for HTTP/GraphQL/gRPC with support for WebSockets, SSE, workflows, profiling, OpenAPI and response diffs";
    homepage = "https://github.com/unkn0wn-root/resterm";
    changelog = "https://github.com/unkn0wn-root/resterm/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "resterm";
  };
})
