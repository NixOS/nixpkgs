{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdwatch";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "vimlinuz";
    repo = "mdwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-128GL2+nqIVR/LjIZoNeXy29fbYcZA4GkTmlx7xVPIE=";
  };

  cargoHash = "sha256-+h4U+qVgfQQvYsynPTfcSTlmP/YJWvYJnRoHOKXh2bs=";

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Simple CLI tool to live-preview Markdown files in your browser";
    homepage = "https://github.com/vimlinuz/mdwatch";
    changelog = "https://github.com/vimlinuz/mdwatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      x123
      vimlinuz
    ];
    mainProgram = "mdwatch";
  };
})
