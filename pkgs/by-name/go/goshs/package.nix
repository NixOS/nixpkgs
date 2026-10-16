{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "goshs";
  version = "2.1.7";

  src = fetchFromGitHub {
    owner = "goshs-labs";
    repo = "goshs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RnpzlAH5wbes40FkCvDhzwbg6oaHbMkg2I/U7Lm9IFs=";
  };

  vendorHash = "sha256-G8QG2h44d8IjhfDGTt8ObTXOzv9jnz8HHB/Ctr4wU8c=";

  patches = [
    # No upstream fix yet; remove when updating to a release that uses goldmark 1.7.17 or later.
    ./CVE-2026-5160.patch
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
    changelog = "https://github.com/goshs-labs/goshs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      fab
      seiarotg
    ];
    mainProgram = "goshs";
  };
})
