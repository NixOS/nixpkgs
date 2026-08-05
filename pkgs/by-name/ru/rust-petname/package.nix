{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-petname";
  version = "3.1.0";

  src = fetchCrate {
    inherit (finalAttrs) version;
    crateName = "petname";
    hash = "sha256-p5sGxGYzvc1b8Ch8MBwluMVFyu2Z8IIqhJzt68o90HQ=";
  };

  cargoHash = "sha256-7+LATYCokoh27sZkIWZ5eW4n1HZSB5fDvQKBeyObCgE=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generate human readable random names";
    homepage = "https://github.com/allenap/rust-petname";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.progrm_jarvis ];
    mainProgram = "petname";
  };
})
