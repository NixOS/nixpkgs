{
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  versionCheckHook,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "goshs";
<<<<<<< HEAD
  version = "1.1.3";
=======
  version = "1.1.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "patrickhener";
    repo = "goshs";
<<<<<<< HEAD
    tag = finalAttrs.version;
    hash = "sha256-oGcGaLPtagyvDNdSkNx4U0wEj57yrYCGnKUGGR4U0aw=";
  };

  vendorHash = "sha256-43Bu4BAmMmd6WrDNztQNCi2OdlzIfbrQC100DkcD4uE=";
=======
    tag = "v${finalAttrs.version}";
    hash = "sha256-0KeIRmqX+YkjZrUXtMPELT+3f06bVaGoBOGuBbqmY8A=";
  };

  vendorHash = "sha256-eu4ytWargmwSfCVfXPykCX0VD7XO7m/T8Her10XpM3s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
