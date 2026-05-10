{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdwatch";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "vimlinuz";
    repo = "mdwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-snmyfhOkCTnRsBcKcTTij5caA2NmSA1Csp3+D6BJcw4=";
  };

  cargoHash = "sha256-CAXHIOC0K062zXNnAD1IW2Sb5Mnpc91A1Lamhc3+NLQ=";

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Simple CLI tool to live-preview Markdown files in your browser";
    homepage = "https://github.com/vimlinuz/mdwatch";
    changelog = "https://github.com/vimlinuz/mdwatch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ x123 ];
    mainProgram = "mdwatch";
  };
})
