{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "stylance-cli";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "basro";
    repo = "stylance-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UVRUPjDxfwnajkY3KUa/615pIo/uAyGu1ngQBSAnEBE=";
  };

  cargoHash = "sha256-bNOOp/6myQX7z/O0gmW/2s9eEog5ZMlL5hD0GFgj7OY=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Library and cli tool for working with scoped CSS in rust";
    mainProgram = "stylance";
    homepage = "https://github.com/basro/stylance-rs";
    changelog = "https://github.com/basro/stylance-rs/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
})
