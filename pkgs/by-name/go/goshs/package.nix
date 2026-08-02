{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch2,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "goshs";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "goshs-labs";
    repo = "goshs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8xSYdLO+2AB044sV3JJw0RXB0RuLQ7eIzWvwgoJdp5k=";
  };

  vendorHash = "sha256-yKNJHs6A7Du9NvGOpwaDmABz6SBMPVzJNoQb7W32IfA=";

  patches = [
    # Remove when updating to 2.1.5 or later.
    (fetchpatch2 {
      name = "CVE-2026-66063+CVE-2026-66064.patch";
      url = "https://github.com/goshs-labs/goshs/commit/f3ef599e409151d1380866e47de8b1afb0bb54fa.patch?full_index=1";
      hash = "sha256-fIKeqWKraaLcocp7aaWE58ffkA1/2NVwR7KMmJfXL5g=";
    })
  ];

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
