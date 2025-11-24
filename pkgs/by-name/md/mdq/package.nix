{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdq";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "yshavit";
    repo = "mdq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ys5Ol/j4IZ4SNp6TjryfHCIgWoEu3ToNp7ffiTZp5BE=";
  };

  cargoHash = "sha256-fwFi/OYlTqRuDDE2TKuvf9T7u0hLyrDejhOwjFDYHAk=";

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
