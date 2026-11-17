{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdwatch";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "vimlinuz";
    repo = "mdwatch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-khChL3VNFzbcl7Lw6PJnMESYAL2JWO6AAvq7t5SVDlg=";
  };

  cargoHash = "sha256-OBknkfnzewil/jKZJEZKAar+QD8h3whw1E4ncAtR99U=";

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
