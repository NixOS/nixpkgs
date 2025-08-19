{
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  versionCheckHook,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "goshs";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "patrickhener";
    repo = "goshs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Me57EOUrpz37fsLYQpmPYjrhIokanS6HmICSjHmqeyU=";
  };

  vendorHash = "sha256-bDfeQQMMMUGLNvmFKEUgGhFkvY3emQp9lNVPbz2QiNk=";

  ldflags = [
    "-s"
    "-w"
  ];

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
