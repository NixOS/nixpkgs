{
  lib,
  fetchCrate,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxvg";
  version = "0.0.5";
  __structuredAttrs = true;

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-I52L0cbj7BYdHVVhJEdhT28DRTg/f7eWpN0qGxfSdhQ=";
  };

  cargoHash = "sha256-+dfM2/SjUTwNAoKC7cjw2Ba1RNp6BwmbR1TxXtp9W4E=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vector image toolchain";
    homepage = "https://github.com/noahbald/oxvg";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyceherrman ];
    mainProgram = "oxvg";
  };
})
