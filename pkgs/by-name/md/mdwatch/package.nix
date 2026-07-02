{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdwatch";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "vimlinuz";
    repo = "mdwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vTwuhhMK0Rr3z1OCqTg8EaYQ3fuFe5S3WHQie/Spw98=";
  };

  cargoHash = "sha256-e3fB3UutnPYX1dxAlK0uu1n589W92MddSxWwDPWQQJc=";

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
