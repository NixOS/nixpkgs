{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "0.31.1";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-A4j6H9HQKDo3uH7cj+GWVFWgozgc7lMwPgfrYs6q3B0=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-oPwTln7OG52yqsatig3OnCJ5KsH3r+W8w/bX+IbhCrk=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # requires unstable rust features
  env.RUSTC_BOOTSTRAP = 1;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast type checker and IDE for Python";
    homepage = "https://github.com/facebook/pyrefly";
    license = lib.licenses.mit;
    mainProgram = "pyrefly";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      cybardev
      QuiNzX
    ];
  };
})
