{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "goshs";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "goshs-labs";
    repo = "goshs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mVgBY1QhQ+tDQnfangqylNeCbBJTSJaM0y7vZ95BU3Y=";
  };

  vendorHash = "sha256-lwZ+F/DaP5pYiaihMxFAo1DokKm6itreX7yG1CNCdWM=";

  ldflags = [ "-s" ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  preCheck = ''
    # Possible race condition
    rm integration/integration_test.go
    # This is handled by nixpkgs
    rm update/update_test.go
  '';

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # utils_test.go:62: route ip+net: no such network interface
    # does not work in sandbox even with __darwinAllowLocalNetworking
    "-skip=^TestGetIPv4Addr$"
  ];

  versionCheckProgramArg = [ "-v" ];

  meta = {
    description = "Simple, yet feature-rich web server written in Go";
    homepage = "https://goshs.de";
    changelog = "https://github.com/goshs-labs/goshs/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      matthiasbeyer
      seiarotg
    ];
    mainProgram = "goshs";
  };
})
