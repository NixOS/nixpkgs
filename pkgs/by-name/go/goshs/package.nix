{
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  lib,
  testers,

  # passthru
  goshs,
}:

buildGoModule (finalAttrs: {
  pname = "goshs";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "patrickhener";
    repo = "goshs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lh4jUz6dtbAwC9ErQrHe5FtxjHLL2gBRTSqLtj33GTc=";
  };

  vendorHash = "sha256-wn+t6xY4zUK6NE5kZSefHYGpMq5whFZ644ij5bDs50I=";

  ldflags = [
    "-s"
    "-w"
  ];

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

  # Disabled until https://github.com/patrickhener/goshs/issues/137 is resolved
  # passthru.tests.version = testers.testVersion {
  #   package = goshs;
  #   command = "goshs -v";
  #   version = "goshs ${finalAttrs.version}";
  # };

  meta = {
    description = "Simple, yet feature-rich web server written in Go";
    homepage = "https://goshs.de";
    changelog = "https://github.com/patrickhener/goshs/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      matthiasbeyer
      seiarotg
    ];
    mainProgram = "goshs";
  };
})
