{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "repeater";
  version = "0.1.10";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "shaankhosla";
    repo = "repeater";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8TWqY78w5cOirLnrBONiratAZQSQrYpp++5dXRlFlNo=";
  };

  cargoHash = "sha256-hngZ55o1YsnstBGjp8++9SsxwfUyu+X4YwZuzMupFTE=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Spaced repetition, in your terminal";
    homepage = "https://github.com/shaankhosla/repeater";
    changelog = "https://github.com/shaankhosla/repeater/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "repeater";
  };
})
