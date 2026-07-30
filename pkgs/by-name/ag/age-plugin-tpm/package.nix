{
  lib,
  callPackage,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  openssl,
  age,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "age-plugin-tpm";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "age-plugin-tpm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1BHVQY8ZexwdjchQiG8aQMEPukq/3ez+QYY1X67DgPc=";
  };

  proxyVendor = true;

  vendorHash = "sha256-CbgDGyVQ9MTYCe56M1VzMnap5P6Y9p4jnK8tyr3zh20=";

  nativeCheckInputs = [
    age
  ];
  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  buildInputs = [
    openssl
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  passthru.tests = {
    encrypt = callPackage ./tests/encrypt.nix { };
    decrypt = nixosTests.age-plugin-tpm-decrypt;
  };

  meta = {
    description = "TPM 2.0 plugin for age (This software is experimental, use it at your own risk)";
    mainProgram = "age-plugin-tpm";
    homepage = "https://github.com/Foxboron/age-plugin-tpm";
    changelog = "https://github.com/Foxboron/age-plugin-tpm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      sgo
    ];
  };
})
