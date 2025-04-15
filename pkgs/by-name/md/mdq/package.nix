{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdq";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "yshavit";
    repo = "mdq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-X+ROsNngMYiAcRaxdb+eZ3qpTqqPPWvlVfcy73gOh+o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-WO3INFfUuH4QMdxE9W7WQ2tvguf3y/kOTHG6KRB1/28=";

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Like jq but for Markdown: find specific elements in a md doc";
    homepage = "https://github.com/yshavit/mdq";
    changelog = "https://github.com/yshavit/mdq/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ DimitarNestorov ];
    mainProgram = "mdq";
  };
})
