{
  lib,
  callPackage,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  swtpm,
  openssl,
  age,
}:

buildGoModule rec {
  pname = "age-plugin-tpm";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "age-plugin-tpm";
    tag = "v${version}";
    hash = "sha256-Vr6simVW5nAWTa8Dro2gar2+O90T8u6h09wTnEnygss=";
  };

  proxyVendor = true;

  vendorHash = "sha256-CbgDGyVQ9MTYCe56M1VzMnap5P6Y9p4jnK8tyr3zh20=";

  nativeCheckInputs = [
    age
    swtpm
  ];

  buildInputs = [
    openssl
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests = {
    encrypt = callPackage ./tests/encrypt.nix { };
    decrypt = nixosTests.age-plugin-tpm-decrypt;
  };

  meta = {
    description = "TPM 2.0 plugin for age (This software is experimental, use it at your own risk)";
    mainProgram = "age-plugin-tpm";
    homepage = "https://github.com/Foxboron/age-plugin-tpm";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      sgo
    ];
  };
}
