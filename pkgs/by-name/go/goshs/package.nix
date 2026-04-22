{
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  lib,
  fetchpatch,
  testers,

  # passthru
  goshs,
}:

buildGoModule (finalAttrs: {
  pname = "goshs";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "patrickhener";
    repo = "goshs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DdGzX1qVz8mA+T9l+V2n7r6ngtV1moypT3sLO7f4OcY=";
  };

  patches = [
    # Fixes the build for 2.0.3
    (fetchpatch {
      url = "https://github.com/patrickhener/goshs/commit/dc4a86e846b5a2e6f7cc97a29a73367dea26f91a.patch";
      hash = "sha256-yXVBxOAp37yVdI5JlFMzSuSwiUaF2gWOfy4GfBVkGSI=";
    })
  ];

  vendorHash = "sha256-R0U/cytan8U9nE/qYHmDUlUfIYhZAcjV2v/uIlZPTCs=";

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

  passthru.tests.version = testers.testVersion {
    package = goshs;
    command = "goshs -v";
    version = "goshs ${finalAttrs.version}";
  };

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
