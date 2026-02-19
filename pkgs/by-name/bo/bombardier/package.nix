{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  bombardier,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "bombardier";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "codesenberg";
    repo = "bombardier";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FoaiUky0WcipkGN8KIpSd+iizinlqtHC5lskvNCnx/Y=";
  };

  vendorHash = "sha256-SezGoDM4xzOj1y/qmvlngYKOVdJnxBD4l9LPVErevUI=";

  subPackages = [
    "."
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.tests = {
    updateScript = nix-update-script { };
    version = testers.testVersion {
      package = bombardier;
    };
  };

  meta = {
    description = "Fast cross-platform HTTP benchmarking tool written in Go";
    homepage = "https://github.com/codesenberg/bombardier";
    changelog = "https://github.com/codesenberg/bombardier/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "bombardier";
  };
})
