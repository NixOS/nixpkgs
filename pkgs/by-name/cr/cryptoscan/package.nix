{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cryptoscan";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "csnp";
    repo = "cryptoscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-94pVrxjnyZhhYrXFy5XzEpHbo79YIQdLm4T2HsDPJLg=";
  };

  vendorHash = "sha256-komX1AmHt2NoF1x6xsNa2RFkfVzOXfYEMPhT0zwMxjw=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.rev}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  subPackages = [ "cmd/cryptoscan/" ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "version" ];

  meta = {
    description = "Cryptographic Discovery Scanner";
    homepage = "https://github.com/csnp/cryptoscan";
    changelog = "https://github.com/csnp/cryptoscan/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cryptoscan";
  };
})
