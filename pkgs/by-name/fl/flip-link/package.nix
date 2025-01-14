{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "flip-link";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "knurling-rs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Nw43I8EIlNGPptsLVxFBapFp6qdFoUOEicHc9FTcm2g=";
  };

  cargoHash = "sha256-OxmRIJ2LtAz+Paxzy1ppxnLliMocKbiJXf/io8mGPNQ=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  checkFlags = [
    # requires embedded toolchains
    "--skip should_link_example_firmware::case_1_normal"
    "--skip should_link_example_firmware::case_2_custom_linkerscript"
    "--skip should_verify_memory_layout"
  ];

  meta = with lib; {
    description = "Adds zero-cost stack overflow protection to your embedded programs";
    mainProgram = "flip-link";
    homepage = "https://github.com/knurling-rs/flip-link";
    changelog = "https://github.com/knurling-rs/flip-link/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      FlorianFranzen
      newam
    ];
  };
}
