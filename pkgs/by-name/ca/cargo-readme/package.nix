{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-readme";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "webern";
    repo = "cargo-readme";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-9Tkw/mgHsTsPgJs/C2gBkBSPGfcfZe+P0KkUp89WZ3c=";
  };

  cargoHash = "sha256-1mCTK4NA2LVKbCgBsF+wvJoXjw6TOMagamNDkFkOzQA=";

  # disable doc tests
  cargoTestFlags = [
    "--bins"
    "--lib"
  ];

  meta = {
    description = "Generate README.md from docstrings";
    mainProgram = "cargo-readme";
    homepage = "https://github.com/livioribeiro/cargo-readme";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
      sshine
    ];
  };
})
