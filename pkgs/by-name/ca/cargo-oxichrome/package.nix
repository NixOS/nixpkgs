{
  lib,
  rustPlatform,
  nix-update-script,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-oxichrome";
  version = "0.2.0";

  # Use fetchCrate over fetchFromGitHub as Git repo does not contain a Cargo.lock file
  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-uMKHRuyFiRNz6QST9fCvUnx/ggdYw2mAHfLi9wHz4AY=";
  };

  cargoHash = "sha256-nMDjQNkqDxTfPnmaT857xo62xYtH3qvw9SqqPwVYRNc=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Develop browser extensions entirely in Rust";
    longDescription = ''
      Framework to build browser extensions entirely in Rust
      with proc macros, type-safe Chrome API bindings, and Leptos for reactive UI.
      Compiles to WebAssembly with zero hand-written JavaScript"
    '';
    homepage = "https://oxichrome.dev";
    downloadPage = "https://github.com/0xsouravm/oxichrome";
    changelog = "https://github.com/0xsouravm/oxichrome/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "cargo-oxichrome";
  };
})
