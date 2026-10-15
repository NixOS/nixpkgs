{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-mutants";
  version = "27.1.0";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "cargo-mutants";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XPcxKBHTwLqHG67d/JNrCBC19DCnLyvLqj26v5MjHvM=";
  };

  cargoHash = "sha256-zKbw73lnOhgjSiCiXezo71S/9DaNfe7HII0QwUADrFA=";

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
