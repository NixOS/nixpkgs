{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.95";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = pname;
    rev = version;
    hash = "sha256-VEjgSmZcy/CZ8EO/mJ2nBOpQviF4A/QQ8SpLLF/9x4c=";
  };

  cargoHash = "sha256-m/F6fI1d8i5lVyURti86FWAs/U14TXpgg/nemLAv4NI=";

  meta = with lib; {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      xrelkd
    ];
    mainProgram = "cargo-expand";
  };
}
