{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;
  pname = "modctl";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "modelpack";
    repo = "modctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A7s2jM+hR5WgeiWzPjjfS/AJy35x6kzewIucz713zLc=";
  };

  vendorHash = "sha256-S1ygAZO3bTFi/3pwmNYE7P/Vqg7AVHpH5YRJ3yzzvyo=";

  ldflags = [
    "-s"
    "-X github.com/modelpack/modctl/pkg/version.GitVersion=v${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];

  meta = {
    description = "CLI tool for managing OCI model artifacts based on Model Spec";
    homepage = "https://github.com/modelpack/modctl";
    changelog = "https://github.com/modelpack/modctl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gbhu753 ];
    mainProgram = "modctl";
  };
})
