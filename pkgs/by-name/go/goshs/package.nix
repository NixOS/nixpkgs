{
  buildGoModule,
  fetchFromGitHub,
  gitUpdater,
  stdenv,
  versionCheckHook,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "goshs";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "patrickhener";
    repo = "goshs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sthe19Wb3zBg4kOh+aDC0CxAwMD9+LcNsy6u7qEj+f8=";
  };

  vendorHash = "sha256-+bb+3ZYzRVxRh1WQEKa+WqH29fHErNWaTcHO70wCwPY=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # utils_test.go:62: route ip+net: no such network interface
    # does not work in sandbox even with __darwinAllowLocalNetworking
    "-skip=^TestGetIPv4Addr$"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Simple, yet feature-rich web server written in Go";
    homepage = "https://goshs.de";
    changelog = "https://github.com/patrickhener/goshs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      matthiasbeyer
      seiarotg
    ];
    mainProgram = "goshs";
  };
})
