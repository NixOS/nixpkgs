{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sync-readme";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "phaazon";
    repo = pname;
    rev = version;
    sha256 = "sha256-n9oIWblTTuXFFQFN6mpQiCH5N7yg5fAp8v9vpB5/DAo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-A1LZKENNOcgUz6eacUo9WCKIZWA7dJa0zuZrgzRr/Js=";

  meta = with lib; {
    description = "Cargo plugin that generates a Markdown section in your README based on your Rust documentation";
    mainProgram = "cargo-sync-readme";
    homepage = "https://github.com/phaazon/cargo-sync-readme";
    changelog = "https://github.com/phaazon/cargo-sync-readme/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      b4dm4n
      matthiasbeyer
    ];
  };
}
