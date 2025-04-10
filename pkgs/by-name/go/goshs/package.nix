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
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "patrickhener";
    repo = "goshs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xq9BqWhUZfk4p5C6d5Eqh98bs0ZDTjpy5KnvhV/9Jew=";
  };

  vendorHash = "sha256-ECh0K3G6VAAJihqzzlWaEQclfXa0Wp/eFL16ABa7r+0=";

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
