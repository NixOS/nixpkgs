{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-expand";
  version = "1.0.117";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-expand";
    rev = version;
    hash = "sha256-IpqDab4JYZoWvtuEU4DkKimOhgZ/c5WsH58cVj4RzGU=";
  };

  cargoHash = "sha256-sAXRA+gStgMDi02yObN7lO2G4vQUeYqmUF09tC7k/Q0=";

  meta = {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      figsoda
      xrelkd
    ];
    mainProgram = "cargo-expand";
  };
}
