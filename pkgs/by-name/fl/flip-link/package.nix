{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "flip-link";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = "flip-link";
    rev = "v${version}";
    hash = "sha256-HYNaHXgI02xY1/eBkwLPN1AGwO6w98tCjwvP8YinuxE=";
  };

  cargoHash = "sha256-hfDf3ipprKggoQ0xR66arRkBaXf4rntoRTgzvXjahUg=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  checkFlags = [
    # requires embedded toolchains
    "--skip should_link_example_firmware::case_1_normal"
    "--skip should_link_example_firmware::case_2_custom_linkerscript"
    "--skip should_verify_memory_layout"
  ];

  meta = {
    description = "Adds zero-cost stack overflow protection to your embedded programs";
    mainProgram = "flip-link";
    homepage = "https://github.com/knurling-rs/flip-link";
    changelog = "https://github.com/knurling-rs/flip-link/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      FlorianFranzen
      newam
    ];
  };
}
