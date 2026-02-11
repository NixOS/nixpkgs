{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-mutants";
  version = "26.2.0";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "cargo-mutants";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tBCLjZWtz3R7ak1npc9gQxjX0axl2Tlz1PMbkYUDjfk=";
  };

  cargoHash = "sha256-MljPZCzfnXj5s6tEINkDhvmGNAfgbNTWR7nmd+ft2Wg=";

  # too many tests require internet access
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mutation testing tool for Rust";
    mainProgram = "cargo-mutants";
    homepage = "https://github.com/sourcefrog/cargo-mutants";
    changelog = "https://github.com/sourcefrog/cargo-mutants/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})
